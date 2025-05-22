import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'hour_time_calculator_event.dart';
part 'hour_time_calculator_state.dart';

class HourTimeCalculatorBloc
    extends Bloc<HourTimeCalculatorEvent, HourTimeCalculatorState> {
  final UserHourTimeRepository _userHourTimeRepository;
  final NotificationsService _notificationsService;
  final int _readingNotificationId = 9999;

  HourTimeCalculatorBloc(
    this._userHourTimeRepository,
    this._notificationsService,
  ) : super(HourTimeCalculatorLoadingState()) {
    on<GotHourTimeEvent>(_gotHourTimeEvent);
    on<InsertedHourTimeEvent>(_insertedHourTimeEvent);
    on<RemovedNotificationHourTimeEvent>(_removedNotificationHourTimeEvent);
  }

  Future<void> _gotHourTimeEvent(
    GotHourTimeEvent event,
    Emitter<HourTimeCalculatorState> emit,
  ) async {
    try {
      emit(HourTimeCalculatorLoadingState());

      final userHourTimeModel = await _userHourTimeRepository.getUserHourTime();

      emit(
        HourTimeCalculatorLoadedState(
          userHourTimeModel: userHourTimeModel,
        ),
      );
    } on StorageException catch (e) {
      emit(
        HourTimeCalculatorErrorState(
          errorMessage: 'Erro ao buscar a hora para leitura: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        HourTimeCalculatorErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }

  Future<void> _insertedHourTimeEvent(
    InsertedHourTimeEvent event,
    Emitter<HourTimeCalculatorState> emit,
  ) async {
    try {
      emit(HourTimeCalculatorLoadingState());

      final userHourTime = event.userHourTimeModel;

      final userHourTimeInserted =
          await _userHourTimeRepository.setUserHourTime(
        userHourTime: userHourTime,
      );

      if (userHourTimeInserted == 0) {
        emit(
          HourTimeCalculatorErrorState(
            errorMessage: 'Erro ao inserir buscar a hora de leitura',
          ),
        );
        return;
      }

      final repeatType = switch (userHourTime.repeatHourTimeType) {
        RepeatHourTimeType.daily => RepeatIntervalType.daily,
        RepeatHourTimeType.weekly => RepeatIntervalType.weekly,
      };

      await _notificationsService.periodicallyShowNotification(
        id: _readingNotificationId,
        title: 'A hora da leitura chegou!',
        body: 'A história está esperando a gente!',
        repeatType: repeatType,
        notificationChannel: NotificationChannel.readChannel,
      );

      emit(HourTimeCalculatorInsertedState());
    } on StorageException catch (e) {
      emit(
        HourTimeCalculatorErrorState(
          errorMessage: 'Erro ao inserir a hora de leitura: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        HourTimeCalculatorErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }

  Future<void> _removedNotificationHourTimeEvent(
    RemovedNotificationHourTimeEvent event,
    Emitter<HourTimeCalculatorState> emit,
  ) async {
    try {
      emit(HourTimeCalculatorLoadingState());

      await _notificationsService.cancelNotificationById(
        id: _readingNotificationId,
      );

      emit(HourTimeCalculatorRemovedNotificationState());
    } on Exception catch (e) {
      emit(
        HourTimeCalculatorErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
