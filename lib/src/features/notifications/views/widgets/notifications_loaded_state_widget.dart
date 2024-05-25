import 'package:bookify/src/core/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/features/notifications/views/widgets/notification_widget.dart';
import 'package:flutter/material.dart';

class NotificationsLoadedStateWidget extends StatelessWidget {
  final List<CustomNotification> notifications;

  const NotificationsLoadedStateWidget({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: NotificationWidget(
          notification: notifications[index],
        ),
      ),
    );
  }
}
