import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookifyApp extends StatefulWidget {
  const BookifyApp({super.key});

  @override
  State<BookifyApp> createState() => _BookifyAppState();
}

class _BookifyAppState extends State<BookifyApp> {
  @override
  void initState() {
    super.initState();
    _initializeAppService();
  }

  Future<void> _initializeAppService() async {
    await _checkNotification();
  }

  Future<void> _checkNotification() async {
    await context.read<NotificationsService>().checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookify',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      routes: Routes.routes,
      initialRoute: Routes.initialRoute,
    );
  }
}
