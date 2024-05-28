part of 'readings_timer_bloc.dart';

sealed class ReadingsTimerState {}

final class ReadingsTimerLoadingState extends ReadingsTimerState {}

final class ReadingsTimerEmptyState extends ReadingsTimerState {}

final class ReadingsTimerLoadedState extends ReadingsTimerState {
  final int initialUserTimerInSeconds;

  ReadingsTimerLoadedState({
    required this.initialUserTimerInSeconds,
  });
}

final class ReadingsTimerErrorState extends ReadingsTimerState {
  final String errorMessage;

  ReadingsTimerErrorState({
    required this.errorMessage,
  });
}
