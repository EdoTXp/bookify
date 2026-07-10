import 'package:bookify/src/features/hour_time_calculator/views/hour_time_calculator_page.dart';
import 'package:bookify/src/shared/providers/providers.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:provider/provider.dart';

late MobileAutomator native;

void main() {
  patrolTest(
    'Test diary notification remember for HourTimeCalculatorPage',
    ($) async => await _notificationTest($, isDaily: true),
  );

  patrolTest(
    'Test weekly notification remember for HourTimeCalculatorPage',
    ($) async => await _notificationTest($, isDaily: false),
  );
}

Future<void> _notificationTest(
  PatrolIntegrationTester $, {
  bool isDaily = true,
}) async {
  await _initApp($);
  expect($(#LateCalculateHourButton), findsOneWidget);
  expect($(#ScheduleNowButton), findsOneWidget);

  await $(#ScheduleNowButton).tap();
  await $.pumpAndSettle();

  if (await native.isPermissionDialogVisible()) {
    await native.grantPermissionWhenInUse();
  }

  expect($(#RepeatTimeWidget), findsOneWidget);
  expect($(#HourTimeSelectedWidget), findsOneWidget);

  if (!isDaily) {
    await $(#RepeatTimeWidget).tap();
    await $.pumpAndSettle();

    await $('weekly-dropdown-menu-entry').tap();
    await $.pumpAndSettle();
  }

  await $(#HourTimeSelectedWidget).tap();
  await $.pumpAndSettle();

  await $(#DefineReturnButton).tap();
  await $.pumpAndSettle();

  await $(#FinishButton).tap();
  await $.pumpAndSettle();

  await _setNotificationDate($, isDaily: isDaily);
  await Future.delayed(const Duration(seconds: 3));

  final notifications = await native.getNotifications();
  const title = 'reading-time-notification-title';
  final appNotification = notifications.firstWhere(
    (notification) => notification.title == title,
  );

  expect(appNotification.title, title);

  await native.openNotifications();
  await native.tapOnNotificationBySelector(
    PlatformSelector(
      android: AndroidSelector(text: title),
      ios: IOSSelector(text: title),
    ),
  );

  await _resetEmulatorDate($);

  await native.pressHome();
}

Future<void> _setNotificationDate(
  PatrolIntegrationTester $, {
  required bool isDaily,
}) async {
  if ($.isAndroid) {
    final androidPlatform = native.platform.android;

    await androidPlatform.openPlatformApp(
      androidAppId: GoogleApp.settings,
    );

    await androidPlatform.swipe(
      from: const Offset(0.5, 0.9),
      to: const Offset(0.5, 0.5),
      steps: 40,
    );

    await androidPlatform.tap(
      AndroidSelector(
        className: 'android.widget.TextView',
        textContains: 'Sistema',
      ),
    );
    await androidPlatform.tap(
      AndroidSelector(
        className: 'android.widget.TextView',
        textContains: 'GMT',
      ),
    );
    await androidPlatform.tap(
      AndroidSelector(
        className: 'android.widget.TextView',
        textContains: 'automatiche',
      ),
    );
    await androidPlatform.tap(
      AndroidSelector(
        className: 'android.widget.TextView',
        text: 'Data',
      ),
    );

    if (isDaily) {
      final tomorrowDate = DateTime.now().add(const Duration(days: 1));

      await androidPlatform.tap(
        AndroidSelector(text: tomorrowDate.day.toString()),
      );
    } else {
      final nextWeekDate = DateTime.now().add(const Duration(days: 7));

      await androidPlatform.tap(
        AndroidSelector(text: nextWeekDate.day.toString()),
      );
    }

    await Future.delayed(const Duration(seconds: 3));
    await androidPlatform.tap(AndroidSelector(text: 'Ok'));
  } else if ($.isIOS) {
    // TODO: Implement iOS notification date setting logic.
  }
}

Future<void> _resetEmulatorDate(PatrolIntegrationTester $) async {
  if ($.isAndroid) {
    final androidPlatform = native.platform.android;

    await androidPlatform.openPlatformApp(
      androidAppId: GoogleApp.settings,
    );

    await androidPlatform.tap(
      AndroidSelector(
        className: 'android.widget.TextView',
        textContains: 'automatiche',
      ),
    );
  } else if ($.isIOS) {
    // TODO: Implement iOS notification date setting logic.
  }
}

Future<void> _initApp(PatrolIntegrationTester $) async {
  native = $.platformAutomator.mobile;

  assert(
    await native.isVirtualDevice(),
    'This test is designed to run on a virtual device.',
  );

  await $.pumpWidgetAndSettle(
    MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        title: 'Bookify - Notification Remember Test',
        theme: AppTheme.appLightTheme,
        onGenerateRoute: Routes.onGenerateRoute,
        home: const HourTimeCalculatorPage(),
      ),
    ),
  );
}
