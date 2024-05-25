import 'package:bookify/src/core/services/app_services/notifications_service/custom_notification.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final CustomNotification notification;

  const NotificationWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary,
        ),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100]
            : Colors.black87,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              notification.body,
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'id: ${notification.id}',
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  'channel: ${notification.notificationChannel.channelId()}',
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
