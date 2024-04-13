import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookifyApp extends StatefulWidget {
  const BookifyApp({super.key});

  @override
  State<BookifyApp> createState() => _BookifyAppState();
}

class _BookifyAppState extends State<BookifyApp> {
  late final NotificationsService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = context.read<NotificationsService>();
    _checkForNotificationsOnInitializeApp();
  }

  Future<void> _checkForNotificationsOnInitializeApp() async {
    await _notificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookify',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      navigatorKey: Routes.navigatorKey,
      routes: Routes.routes,
      initialRoute: Routes.initialRoute,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}
