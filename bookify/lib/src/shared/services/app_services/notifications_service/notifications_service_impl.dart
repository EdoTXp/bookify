import 'dart:io';

import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationsServiceImpl implements NotificationsService {
  late final FlutterLocalNotificationsPlugin _notifications;

  NotificationsServiceImpl() {
    _notifications = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupNotificationPermission();
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupNotificationPermission() async {
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('America/Sao_Paulo'),
    );
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    tz.initializeTimeZones();
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
    final String? payload = details.payload;

    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
    }
  }

  @override
  Future<void> cancelNotificationById({required int id}) async {
    await _notifications.cancel(id);
  }

  @override
  Future<void> scheduleNotification({
    required CustomNotification notification,
  }) async {
    await _notifications.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(
        notification.scheduledDate,
        tz.local,
      ),
      NotificationDetails(
        android: AndroidNotificationDetails(
          notification.channelId,
          notification.channelName,
        ),
      ),
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> checkForNotifications() async {
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details?.notificationResponse != null &&
        details!.didNotificationLaunchApp) {
      _onDidReceiveNotificationResponse(details.notificationResponse!);
    }
  }
}
