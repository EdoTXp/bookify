import 'package:bookify/src/core/models/custom_notification_model.dart';

enum RepeatIntervalType {
  daily,
  weekly,
}

abstract interface class NotificationsService {
  Future<void> cancelNotificationById({required int id});
  Future<void> scheduleNotification(CustomNotificationModel notification);
  Future<void> periodicallyShowNotification({
    required int id,
    required String title,
    required String body,
    required RepeatIntervalType repeatType,
    required NotificationChannel notificationChannel,
  });
  Future<void> checkForNotifications();
  Future<List<CustomNotificationModel>> getNotifications();
}
