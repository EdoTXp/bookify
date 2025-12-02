import 'dart:io';

import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notification_navigator.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsServiceImpl implements NotificationsService {
  late final FlutterLocalNotificationsPlugin _notifications;

  NotificationsServiceImpl() {
    _notifications = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
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

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneName.identifier));
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@drawable/ic_stat_ic_notification',
    );

    final iosSettings = DarwinInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onTapOnNotification,
    );
    tz.initializeTimeZones();
  }

  void _onTapOnNotification(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      final NotificationResponse(:id, :payload) = notificationResponse;
      _navigateToNotificationPage(payload, id);
    }
  }

  void _navigateToNotificationPage(String? payload, int? id) {
    if (payload != null && payload.isNotEmpty) {
      NotificationNavigator.navigateTo(
        payload,
        id,
      );
    }
  }

  NotificationDetails _getNotificationDetails(
    NotificationChannel channel,
    String bigText,
  ) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.channelId(),
        channel.toString(),
        channelDescription: channel.description(),
        color: AppColor.bookifySecondaryColor,
        styleInformation: BigTextStyleInformation(
          bigText,
        ),
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: channel.toString(),
      ),
    );
  }

  @override
  Future<void> scheduleNotification(
    CustomNotificationModel notification,
  ) async {
    await _notifications.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      tz.TZDateTime.from(
        notification.scheduledDate,
        tz.local,
      ),
      _getNotificationDetails(
        notification.notificationChannel,
        notification.body,
      ),
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> periodicallyShowNotificationWithSpecificDate({
    required int id,
    required String title,
    required String body,
    required RepeatHourTimeType repeatType,
    required DateTime scheduledDate,
    required NotificationChannel notificationChannel,
  }) async {
    final dateTimeComponents = switch (repeatType) {
      RepeatHourTimeType.daily => DateTimeComponents.time,
      RepeatHourTimeType.weekly => DateTimeComponents.dayOfWeekAndTime,
    };

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      ),
      _getNotificationDetails(
        notificationChannel,
        body,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  @override
  Future<void> cancelNotificationById({required int id}) async {
    await _notifications.cancel(id);
  }

  @override
  Future<void> checkForNotifications() async {
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      if (details.notificationResponse != null) {
        _onTapOnNotification(details.notificationResponse!);
      }
    }
  }

  @override
  Future<List<CustomNotificationModel>> getNotifications() async {
    final pendingNotifications =
        await _notifications.pendingNotificationRequests();

    final notifications = pendingNotifications
        .map(
          (notification) => CustomNotificationModel(
            id: notification.id,
            notificationChannel: notification.payload!.isEmpty
                ? NotificationChannel.readChannel
                : NotificationChannel.loanChannel,
            title: notification.title ?? 'sem título',
            body: notification.body ?? 'sem corpo',
            scheduledDate: DateTime.now(),
          ),
        )
        .toList();

    return notifications;
  }
}
