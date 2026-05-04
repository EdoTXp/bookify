import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'programming_reading_event.dart';
part 'programming_reading_state.dart';

class ProgrammingReadingBloc
    extends Bloc<ProgrammingReadingEvent, ProgrammingReadingState> {
  final UserHourTimeRepository _userHourTimeRepository;
  final NotificationsService _notificationsService;
  final int _readingNotificationId = 9999;

  ProgrammingReadingBloc(
    this._userHourTimeRepository,
    this._notificationsService,
  ) : super(ProgrammingReadingLoadingState()) {
    on<GotHourTimeEvent>(_gotHourTimeEvent);
    on<InsertedHourTimeEvent>(_insertedHourTimeEvent);
    on<RemovedNotificationHourTimeEvent>(_removedNotificationHourTimeEvent);
  }

  Future<void> _gotHourTimeEvent(
    GotHourTimeEvent event,
    Emitter<ProgrammingReadingState> emit,
  ) async {
    try {
      emit(ProgrammingReadingLoadingState());

      final userHourTimeModel = await _userHourTimeRepository.getUserHourTime();

      emit(
        ProgrammingReadingLoadedState(
          userHourTimeModel: userHourTimeModel,
        ),
      );
    } on StorageException {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.readFailed,
          errorDescriptionMessage: 'Failed to load reading hour time',
        ),
      );
    } on Exception {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'Unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _insertedHourTimeEvent(
    InsertedHourTimeEvent event,
    Emitter<ProgrammingReadingState> emit,
  ) async {
    try {
      emit(ProgrammingReadingLoadingState());

      final userHourTime = event.userHourTimeModel;

      final userHourTimeInserted = await _userHourTimeRepository
          .setUserHourTime(
            userHourTime: userHourTime,
          );

      if (userHourTimeInserted == 0) {
        emit(
          ProgrammingReadingErrorState(
            errorCode: StorageErrorCode.writeFailed,
            errorDescriptionMessage: 'Failed to insert reading hour time',
          ),
        );
        return;
      }

      await _notificationsService.periodicallyShowNotificationWithSpecificDate(
        id: _readingNotificationId,
        title: 'A hora da leitura chegou!',
        body: 'A história está esperando a gente!',
        repeatType: userHourTime.repeatHourTimeType,
        scheduledDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          userHourTime.startingHour,
          userHourTime.startingMinute,
        ),
        notificationChannel: NotificationChannel.readChannel,
      );

      emit(ProgrammingReadingInsertedState());
    } on StorageException {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.writeFailed,
          errorDescriptionMessage: 'Failed to insert reading hour time',
        ),
      );
    } on Exception {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'Unexpected error occurred',
        ),
      );
    }
  }

  Future<void> _removedNotificationHourTimeEvent(
    RemovedNotificationHourTimeEvent event,
    Emitter<ProgrammingReadingState> emit,
  ) async {
    try {
      emit(ProgrammingReadingLoadingState());

      await _notificationsService.cancelNotificationById(
        id: _readingNotificationId,
      );

      emit(ProgrammingReadingRemovedNotificationState());
    } on Exception {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}
