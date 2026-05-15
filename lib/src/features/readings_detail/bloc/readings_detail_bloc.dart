import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/reading_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'readings_detail_event.dart';
part 'readings_detail_state.dart';

class ReadingsDetailBloc
    extends Bloc<ReadingsDetailEvent, ReadingsDetailState> {
  final BookService _bookService;
  final ReadingService _readingService;

  ReadingsDetailBloc(
    this._bookService,
    this._readingService,
  ) : super(ReadingsDetailLoadingState()) {
    on<UpdatedReadingsEvent>(_updatedReadingsEvent);
    on<FinishedReadingsEvent>(_finishedReadingsEvent);
  }

  Future<void> _updatedReadingsEvent(
    UpdatedReadingsEvent event,
    Emitter<ReadingsDetailState> emit,
  ) async {
    try {
      emit(ReadingsDetailLoadingState());

      final readingUpdatedRow = await _readingService.update(
        readingModel: event.readingModel,
      );

      if (readingUpdatedRow != 1) {
        emit(
          ReadingsDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Error on updating reading',
          ),
        );
        return;
      }

      emit(ReadingsDetailUpdatedState());
    } on LocalDatabaseException catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _finishedReadingsEvent(
    FinishedReadingsEvent event,
    Emitter<ReadingsDetailState> emit,
  ) async {
    try {
      emit(ReadingsDetailLoadingState());

      final bookUpdatedStatusRow = await _bookService.updateStatus(
        id: event.bookId,
        status: BookStatus.library,
      );

      if (bookUpdatedStatusRow != 1) {
        emit(
          ReadingsDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Error on updating book status',
          ),
        );
        return;
      }

      final readingDeletedRow = await _readingService.delete(
        readingId: event.readingId,
      );

      if (readingDeletedRow != 1) {
        emit(
          ReadingsDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Error on deleting reading',
          ),
        );
        return;
      }

      emit(ReadingsDetailFinishedState());
    } on LocalDatabaseException catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
