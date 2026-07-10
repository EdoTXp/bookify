import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bookify/src/domain/models/custom_notification_model.dart';

abstract interface class NotificationsService {
  Future<void> scheduleNotification(
    CustomNotificationModel notification,
    DateTime scheduledDate,
  );

  Future<void> periodicallyShowNotificationWithSpecificDate({
    required CustomNotificationModel notification,
    required RepeatHourTimeType repeatType,
    required DateTime scheduledDate,
  });

  Future<void> checkForNotifications();

  Future<List<CustomNotificationModel>> getNotifications();

  Future<void> cancelNotificationById({required int id});
}
