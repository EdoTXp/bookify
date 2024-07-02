import 'package:bookify/src/core/services/app_services/notifications_service/custom_notification.dart';

enum RepeatIntervalType {
  daily,
  weekly,
}

abstract interface class NotificationsService {
  Future<void> cancelNotificationById({required int id});
  Future<void> scheduleNotification(CustomNotification notification);
  Future<void> periodicallyShowNotification({
    required int id,
    required String title,
    required String body,
    required RepeatIntervalType repeatType,
    required NotificationChannel notificationChannel,
  });
  Future<void> checkForNotifications();
  Future<List<CustomNotification>> getNotifications();
}
