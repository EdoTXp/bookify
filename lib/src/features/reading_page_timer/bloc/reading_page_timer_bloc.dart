import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reading_page_timer_event.dart';
part 'reading_page_timer_state.dart';

class ReadingPageTimerBloc
    extends Bloc<ReadingPageTimerEvent, ReadingPageTimerState> {
  final UserPageReadingTimeRepository _userPageReadingTimeRepository;

  ReadingPageTimerBloc(
    this._userPageReadingTimeRepository,
  ) : super(ReadingPageTimerLoadingState()) {
    on<InsertedReadingPageTimeEvent>(_insertedReadingPageTimeEvent);
  }

  Future<void> _insertedReadingPageTimeEvent(
    InsertedReadingPageTimeEvent event,
    Emitter<ReadingPageTimerState> emit,
  ) async {
    try {
      emit(ReadingPageTimerLoadingState());

      final userPageReading = UserPageReadingTimeModel(
        pageReadingTimeSeconds: event.readingPageTime,
      );

      final userPageReadingTimeInserted = await _userPageReadingTimeRepository
          .setUserPageReadingTime(
            userPageReadingTime: userPageReading,
          );

      if (userPageReadingTimeInserted == 0) {
        emit(
          ReadingPageTimerErrorState(
            errorCode: StorageErrorCode.writeFailed,
            errorDescriptionMessage:
                'Failed to save page reading time. Please try again.',
          ),
        );
        return;
      }

      emit(ReadingPageTimerInsertedState());
    } on StorageException {
      emit(
        ReadingPageTimerErrorState(
          errorCode: StorageErrorCode.writeFailed,
          errorDescriptionMessage:
              ' Failed to save page reading time. Please try again.',
        ),
      );
    } on Exception {
      emit(
        ReadingPageTimerErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}
