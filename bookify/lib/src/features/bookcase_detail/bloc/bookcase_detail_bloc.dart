import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'bookcase_detail_event.dart';
part 'bookcase_detail_state.dart';

class BookcaseDetailBloc
    extends Bloc<BookcaseDetailEvent, BookcaseDetailState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;

  BookcaseDetailBloc(
    this._bookService,
    this._bookcaseService,
  ) : super(BookcaseDetailLoadingState()) {
    on<GotBookcaseBooksEvent>(_gotBookcaseBooks);
    on<DeletedBookcaseEvent>(_deletedBookcase);
  }

  Future<void> _gotBookcaseBooks(
      GotBookcaseBooksEvent event, Emitter<BookcaseDetailState> emit) async {
    try {
      emit(BookcaseDetailLoadingState());

      final bookcaseRelationships = await _bookcaseService
          .getAllBookcaseRelationships(bookcaseId: event.bookcaseId);

      if (bookcaseRelationships.isEmpty) {
        emit(BookcaseDetailBooksEmptyState());
        return;
      }

      final books = <BookModel>[];

      for (var relationship in bookcaseRelationships) {
        final bookModel = await _bookService.getBookById(
          id: relationship['bookId'] as String,
        );

        books.add(bookModel);
      }

      emit(BookcaseDetailBooksLoadedState(books: books));
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseDetailErrorState(
            errorMessage: 'Erro no database: ${e.message}'),
      );
    } catch (e) {
      emit(
        BookcaseDetailErrorState(
            errorMessage: 'Ocorreu um erro não esperado: $e'),
      );
    }
  }

  Future<void> _deletedBookcase(
      DeletedBookcaseEvent event, Emitter<BookcaseDetailState> emit) async {
    try {
      emit(BookcaseDetailLoadingState());

      final bookcaseDeletedRow =
          await _bookcaseService.deleteBookcase(bookcaseId: event.bookcaseId);

      if (bookcaseDeletedRow == -1) {
        emit(BookcaseDetailErrorState(errorMessage: 'Impossível deletar a estante'));
        return;
      }

      emit(BookcaseDetailDeletedState());
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseDetailErrorState(
            errorMessage: 'Erro no database: ${e.message}'),
      );
    } catch (e) {
      emit(
        BookcaseDetailErrorState(
            errorMessage: 'Ocorreu um erro não esperado: $e'),
      );
    }
  }
}
