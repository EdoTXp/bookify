import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/domain/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_on_bookcase_detail_event.dart';
part 'book_on_bookcase_detail_state.dart';

class BookOnBookcaseDetailBloc
    extends Bloc<BookOnBookcaseDetailEvent, BookOnBookcaseDetailState> {
  final BookcaseService _bookcaseService;

  BookOnBookcaseDetailBloc(
    this._bookcaseService,
  ) : super(BookOnBookcaseDetailLoadingState()) {
    on<GotCountOfBookcasesByBookEvent>(_gotCountOfBookcasesByBookEvent);
    on<DeletedBookOnBookcaseEvent>(_deletedBookOnBookcaseEvent);
  }

  Future<void> _gotCountOfBookcasesByBookEvent(
    GotCountOfBookcasesByBookEvent event,
    Emitter<BookOnBookcaseDetailState> emit,
  ) async {
    try {
      emit(BookOnBookcaseDetailLoadingState());

      final bookcasesCount = await _bookcaseService.countBookcasesByBook(
        bookId: event.bookId,
      );

      emit(
        BookOnBookcaseDetailLoadedState(
          bookcasesCount: bookcasesCount,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(
        BookOnBookcaseDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookOnBookcaseDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _deletedBookOnBookcaseEvent(
    DeletedBookOnBookcaseEvent event,
    Emitter<BookOnBookcaseDetailState> emit,
  ) async {
    try {
      emit(BookOnBookcaseDetailLoadingState());

      final deletedBook = await _bookcaseService.deleteBookcaseRelationship(
        bookcaseId: event.bookcaseId,
        bookId: event.bookId,
      );

      if (deletedBook != 1) {
        emit(
          BookOnBookcaseDetailErrorState(
            errorCode: LocalDatabaseErrorCode.operationFailed,
            errorDescriptionMessage:
                'Failed to delete the book from the bookcase. Please try again.',
          ),
        );
        return;
      }

      emit(BookOnBookcaseDetailDeletedState());
    } on LocalDatabaseException catch (e) {
      emit(
        BookOnBookcaseDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookOnBookcaseDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
