part of 'programming_reading_bloc.dart';

sealed class ProgrammingReadingState {}

final class ProgrammingReadingLoadingState extends ProgrammingReadingState {}

final class ProgrammingReadingLoadedState extends ProgrammingReadingState {
  final UserHourTimeModel? userHourTimeModel;

  ProgrammingReadingLoadedState({
    required this.userHourTimeModel,
  });
}

final class ProgrammingReadingInsertedState extends ProgrammingReadingState {}

final class ProgrammingReadingRemovedNotificationState
    extends ProgrammingReadingState {}

final class ProgrammingReadingErrorState extends ProgrammingReadingState {
  final String errorMessage;

  ProgrammingReadingErrorState({
    required this.errorMessage,
  });
}
