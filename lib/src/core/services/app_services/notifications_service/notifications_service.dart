import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';

abstract interface class NotificationsService {
  Future<void> cancelNotificationById({required int id});
  Future<void> scheduleNotification(CustomNotificationModel notification);

  Future<void> periodicallyShowNotificationWithSpecificDate({
    required int id,
    required String title,
    required String body,
    required RepeatHourTimeType repeatType,
    required DateTime scheduledDate,
    required NotificationChannel notificationChannel,
  });
  Future<void> checkForNotifications();
  Future<List<CustomNotificationModel>> getNotifications();
}
