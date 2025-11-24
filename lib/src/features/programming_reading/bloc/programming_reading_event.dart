part of 'programming_reading_bloc.dart';

sealed class ProgrammingReadingEvent {}

final class GotHourTimeEvent extends ProgrammingReadingEvent {}

final class InsertedHourTimeEvent extends ProgrammingReadingEvent {
  final UserHourTimeModel userHourTimeModel;

  InsertedHourTimeEvent({
    required this.userHourTimeModel,
  });
}

final class RemovedNotificationHourTimeEvent extends ProgrammingReadingEvent {}
