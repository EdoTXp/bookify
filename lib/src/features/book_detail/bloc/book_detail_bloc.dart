import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/helpers/book_status/book_status_extension.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/core/services/book_service/book_service.dart';

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

      final bookIsInserted = await _bookService.verifyBookIsAlreadyInserted(
        id: event.bookId,
      );

      emit(BookDetailLoadedState(bookIsInserted: bookIsInserted));
    } on LocalDatabaseException catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _insertBook(
    BookInsertedEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    try {
      emit(BookDetailLoadingState());

      final bookInserted = await _bookService.insertCompleteBook(
        bookModel: event.bookModel,
      );

      if (bookInserted != 1) {
        emit(
          BookDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Error on insert book',
          ),
        );
        return;
      }

      emit(BookDetailLoadedState(bookIsInserted: true));
    } on LocalDatabaseException catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _removeBook(
    BookRemovedEvent event,
    Emitter<BookDetailState> emit,
  ) async {
    try {
      emit(BookDetailLoadingState());

      final bookStatus = await _bookService.getBookStatus(id: event.bookId);

      if (bookStatus != BookStatus.library) {
        emit(
          BookDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage:
                'Impossible to remove this book because is: ${bookStatus.label}.',
          ),
        );
        return;
      }

      final bookRemoved = await _bookService.deleteBook(id: event.bookId);
      if (bookRemoved != 1) {
        emit(
          BookDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Error on remove book',
          ),
        );
        return;
      }
      emit(BookDetailLoadedState(bookIsInserted: false));
      return;
    } on LocalDatabaseException catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
