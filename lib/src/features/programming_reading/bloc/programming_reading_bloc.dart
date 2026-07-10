import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/domain/models/user_hour_time_model.dart';
import 'package:bookify/src/data/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/domain/models/custom_notification_model.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'programming_reading_event.dart';
part 'programming_reading_state.dart';

class ProgrammingReadingBloc
    extends Bloc<ProgrammingReadingEvent, ProgrammingReadingState> {
  final UserHourTimeRepository _userHourTimeRepository;
  final NotificationsService _notificationsService;

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
    } on StorageException catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
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

      const readingChannel = NotificationChannel.readChannel;

      await _notificationsService.periodicallyShowNotificationWithSpecificDate(
        notification: CustomNotificationModel(
          id: readingChannel.fixedId,
          title: event.readingTimeNotificationTitle,
          body: event.readingTimeNotificationBody,
          notificationChannel: readingChannel,
          payload: event.notificationPayloadRoute,
        ),
        repeatType: userHourTime.repeatHourTimeType,
        scheduledDate: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          userHourTime.startingHour,
          userHourTime.startingMinute,
        ),
      );

      emit(ProgrammingReadingInsertedState());
    } on StorageException catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
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

      final userHourTimeRemoved = await _userHourTimeRepository
          .removeUserHourTime();

      if (userHourTimeRemoved == 0) {
        emit(
          ProgrammingReadingErrorState(
            errorCode: StorageErrorCode.writeFailed,
            errorDescriptionMessage: 'Failed to remove reading hour time',
          ),
        );
        return;
      }

      await _notificationsService.cancelNotificationById(
        id: NotificationChannel.readChannel.fixedId,
      );

      emit(ProgrammingReadingRemovedNotificationState());
    } on StorageException catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ProgrammingReadingErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
