import 'dart:io';

import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/enums/platform_error_code.dart';
import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bookify/src/domain/models/custom_notification_model.dart';
import 'package:bookify/src/core/extensions/notification_channel/notification_channel_extension.dart';
import 'package:bookify/src/domain/services/notifications_service/notification_navigator.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service.dart';
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
            AndroidFlutterLocalNotificationsPlugin
          >()!
          .requestNotificationsPermission();

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()!
          .requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()!
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

    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onTapOnNotification,
    );
    tz.initializeTimeZones();
  }

  void _onTapOnNotification(
    NotificationResponse notificationResponse,
  ) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      final NotificationResponse(
        :id,
        :payload,
      ) = notificationResponse;
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
        channel.getChannelId(),
        channel.label,
        channelDescription: channel.description(),
        color: AppColor.bookifySecondaryColor,
        styleInformation: BigTextStyleInformation(
          bigText,
        ),
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(
        categoryIdentifier: channel.label,
      ),
    );
  }

  @override
  Future<void> scheduleNotification(
    CustomNotificationModel notification,
    DateTime scheduledDate,
  ) async {
    try {
      await _notifications.zonedSchedule(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        scheduledDate: tz.TZDateTime.from(
          scheduledDate,
          tz.local,
        ),
        notificationDetails: _getNotificationDetails(
          notification.notificationChannel,
          notification.body,
        ),
        payload: notification.payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> periodicallyShowNotificationWithSpecificDate({
    required CustomNotificationModel notification,
    required RepeatHourTimeType repeatType,
    required DateTime scheduledDate,
  }) async {
    try {
      final dateTimeComponents = switch (repeatType) {
        RepeatHourTimeType.daily => DateTimeComponents.time,
        RepeatHourTimeType.weekly => DateTimeComponents.dayOfWeekAndTime,
      };

      await _notifications.zonedSchedule(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        scheduledDate: tz.TZDateTime.from(
          scheduledDate,
          tz.local,
        ),
        payload: notification.payload,
        notificationDetails: _getNotificationDetails(
          notification.notificationChannel,
          notification.body,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: dateTimeComponents,
      );
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> cancelNotificationById({required int id}) async {
    try {
      await _notifications.cancel(id: id);
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> checkForNotifications() async {
    try {
      final details = await _notifications.getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        if (details.notificationResponse != null) {
          _onTapOnNotification(details.notificationResponse!);
        }
      }
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<List<CustomNotificationModel>> getNotifications() async {
    try {
      final pendingNotifications = await _notifications
          .pendingNotificationRequests();

      final notifications = pendingNotifications
          .map(
            (notification) => CustomNotificationModel(
              id: notification.id,
              notificationChannel: NotificationChannel.fromId(notification.id),
              title: notification.title ?? '--',
              body: notification.body ?? '--',
              payload: notification.payload,
            ),
          )
          .toList();

      return notifications;
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
