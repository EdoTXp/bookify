part of 'hour_time_calculator_bloc.dart';

sealed class HourTimeCalculatorState {}

final class HourTimeCalculatorLoadingState extends HourTimeCalculatorState {}

final class HourTimeCalculatorLoadedState extends HourTimeCalculatorState {
  final UserHourTimeModel? userHourTimeModel;

  HourTimeCalculatorLoadedState({
    required this.userHourTimeModel,
  });
}

final class HourTimeCalculatorInsertedState extends HourTimeCalculatorState {}

final class HourTimeCalculatorRemovedNotificationState
    extends HourTimeCalculatorState {}

final class HourTimeCalculatorErrorState extends HourTimeCalculatorState {
  final String errorMessage;

  HourTimeCalculatorErrorState({
    required this.errorMessage,
  });
}
