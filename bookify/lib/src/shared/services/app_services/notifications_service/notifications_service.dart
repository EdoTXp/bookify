import 'package:bookify/src/shared/services/app_services/notifications_service/custom_notification.dart';

abstract interface class NotificationsService {
  Future<void> cancelNotificationById({required int id});
  Future<void> scheduleNotification(CustomNotification notification);
  Future<void> periodicallyShowNotification({
    required int id,
    required String title,
    required String body,
    required NotificationChannel notificationChannel,
  });
  Future<void> checkForNotifications();
}
