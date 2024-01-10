import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/shared/services/book_service/book_service.dart';

part 'book_detail_event.dart';
part 'book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final BookService _bookService;

  BookDetailBloc(
    this._bookService,
  ) : super(BookDetailLoadingState()) {
    on<VerifiedBookIsInsertedEvent>(_verifyBookIsInserted);
    on<BookInsertedEvent>(_insertBook);
    on<BookRemovedEvent>(_removeBook);
  }

  Future<void> _verifyBookIsInserted(
    VerifiedBookIsInsertedEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    try {
      emit(BookDetailLoadingState());

      final bookIsInserted =
          await _bookService.verifyBookIsAlreadyInserted(id: event.bookId);

      emit(BookDetailLoadedState(bookIsInserted: bookIsInserted));
    } on LocalDatabaseException catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro no database: ${e.toString()}',
      ));
    } catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro não esperado: ${e.toString()}',
      ));
    }
  }

  Future<void> _insertBook(
    BookInsertedEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    try {
      emit(BookDetailLoadingState());

      final bookInserted =
          await _bookService.insertCompleteBook(bookModel: event.bookModel);

      if (bookInserted != 1) {
        emit(
            BookDetailErrorState(errorMessage: 'Erro no inserimento do livro'));
        return;
      }

      emit(BookDetailLoadedState(bookIsInserted: true));
    } on LocalDatabaseException catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro no database: ${e.toString()}',
      ));
    } catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro não esperado: ${e.toString()}',
      ));
    }
  }

  Future<void> _removeBook(
    BookRemovedEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    try {
      emit(BookDetailLoadingState());

      final bookRemoved = await _bookService.deleteBook(id: event.bookId);

      if (bookRemoved != 1) {
        emit(BookDetailErrorState(errorMessage: 'Erro ao remover o livro'));
        return;
      }

      emit(BookDetailLoadedState(bookIsInserted: false));
    } on LocalDatabaseException catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro no database: ${e.toString()}',
      ));
    } catch (e) {
      emit(BookDetailErrorState(
        errorMessage: 'Ocorreu um erro não esperado: ${e.toString()}',
      ));
    }
  }

  Future<void> dispose() async => await close();
}
