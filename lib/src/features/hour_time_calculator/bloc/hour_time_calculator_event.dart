part of 'hour_time_calculator_bloc.dart';

sealed class HourTimeCalculatorEvent {}

final class GotHourTimeEvent extends HourTimeCalculatorEvent {}

final class InsertedHourTimeEvent extends HourTimeCalculatorEvent {
  final UserHourTimeModel userHourTimeModel;

  InsertedHourTimeEvent({
    required this.userHourTimeModel,
  });
}

final class RemovedNotificationHourTimeEvent extends HourTimeCalculatorEvent {}
