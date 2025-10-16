import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/features/notifications/views/widgets/notification_widget.dart';
import 'package:flutter/material.dart';

class NotificationsLoadedStateWidget extends StatelessWidget {
  final List<CustomNotificationModel> notifications;

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
