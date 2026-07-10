part of 'programming_reading_bloc.dart';

sealed class ProgrammingReadingEvent {}

final class GotHourTimeEvent extends ProgrammingReadingEvent {}

final class InsertedHourTimeEvent extends ProgrammingReadingEvent {
  final UserHourTimeModel userHourTimeModel;
  final String readingTimeNotificationTitle;
  final String readingTimeNotificationBody;
  final String notificationPayloadRoute;

  InsertedHourTimeEvent({
    required this.userHourTimeModel,
    required this.readingTimeNotificationTitle,
    required this.readingTimeNotificationBody,
    required this.notificationPayloadRoute,
  });
}

final class RemovedNotificationHourTimeEvent extends ProgrammingReadingEvent {}
