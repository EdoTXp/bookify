import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookcase_books_insertion_event.dart';
part 'bookcase_books_insertion_state.dart';

class BookcaseBooksInsertionBloc
    extends Bloc<BookcaseBooksInsertionEvent, BookcaseBooksInsertionState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;

  BookcaseBooksInsertionBloc(
    this._bookService,
    this._bookcaseService,
  ) : super(BookcaseBooksInsertionLoadingState()) {
    on<GotAllBooksForThisBookcaseEvent>(_gotAllBooksForThisBookcaseEvent);
    on<InsertBooksOnBookcaseEvent>(_insertBooksOnBookcaseEvent);
  }

  Future<void> _gotAllBooksForThisBookcaseEvent(
    GotAllBooksForThisBookcaseEvent event,
    Emitter<BookcaseBooksInsertionState> emit,
  ) async {
    try {
      emit(BookcaseBooksInsertionLoadingState());

      final booksList = await _bookService.getAllBook();

      if (booksList.isEmpty) {
        emit(
          BookcaseBooksInsertionEmptyState(
            message:
                'Nenhum livro cadastrado. Volte à Página início para cadastrar.',
          ),
        );
        return;
      }

      final relationshipList = await _bookcaseService
          .getAllBookcaseRelationships(bookcaseId: event.bookcaseId);

      // Remove books that are already part of the relationship.
      if (relationshipList.isNotEmpty) {
        for (var relationShip in relationshipList) {
          booksList.removeWhere(
            (book) => book.id == relationShip['bookId'],
          );
        }
      }

      // If all books have already been inserted, it will emit an EmptyState to indicate that no more books can be inserted.
      // Otherwise, it will emit the list with books.
      emit(
        (booksList.isNotEmpty)
            ? BookcaseBooksInsertionLoadedState(
                books: booksList,
              )
            : BookcaseBooksInsertionEmptyState(
                message:
                    'Todos os livros cadastrados já foram adicionados nessa estante.',
              ),
      );
    } on LocalDatabaseException catch (e) {
      emit(BookcaseBooksInsertionErrorState(
          errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcaseBooksInsertionErrorState(
          errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _insertBooksOnBookcaseEvent(
    InsertBooksOnBookcaseEvent event,
    Emitter<BookcaseBooksInsertionState> emit,
  ) async {
    try {
      emit(BookcaseBooksInsertionLoadingState());

      final books = event.books;

      for (var book in books) {
        int insertedRow = await _bookcaseService.insertBookcaseRelationship(
          bookcaseId: event.bookcaseId,
          bookId: book.id,
        );

        if (insertedRow == 0) {
          emit(
            BookcaseBooksInsertionErrorState(
              errorMessage: 'Erro ao inserir o livro ${book.title}',
            ),
          );
          return;
        }
      }

      emit(BookcaseBooksInsertionInsertedState());
    } on LocalDatabaseException catch (e) {
      emit(BookcaseBooksInsertionErrorState(
          errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcaseBooksInsertionErrorState(
          errorMessage: 'Erro inesperado: $e'));
    }
  }
}
