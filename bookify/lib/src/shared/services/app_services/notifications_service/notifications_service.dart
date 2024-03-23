import 'package:bookify/src/shared/services/app_services/notifications_service/custom_notification.dart';

abstract interface class NotificationsService {
Future<void> cancelNotificationById({required int id});
Future<void> scheduleNotification({ required CustomNotification notification});
Future<void> checkForNotifications();
}