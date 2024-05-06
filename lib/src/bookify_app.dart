import 'package:bookify/src/shared/blocs/user_theme_bloc/user_theme_bloc.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BookifyApp extends StatefulWidget {
  const BookifyApp({super.key});

  @override
  State<BookifyApp> createState() => _BookifyAppState();
}

class _BookifyAppState extends State<BookifyApp> {
  late final UserThemeBloc _userThemeBloc;
  late final NotificationsService _notificationService;
  ThemeMode? _themeMode;

  @override
  void initState() {
    super.initState();
    _userThemeBloc = context.read<UserThemeBloc>()
      ..add(
        GotUserThemeEvent(),
      );

    _notificationService = context.read<NotificationsService>();
    _checkForNotificationsOnInitializeApp();
  }

  Future<void> _checkForNotificationsOnInitializeApp() async {
    await _notificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserThemeBloc, UserThemeState>(
      bloc: _userThemeBloc,
      listener: (context, state) {
        if (state is UserThemeLoadedState) {
          setState(() {
            _themeMode = state.themeMode;
          });
        }
      },
      child: MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: _themeMode,
        navigatorKey: Routes.navigatorKey,
        routes: Routes.routes,
        initialRoute: Routes.initialRoute,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
      ),
    );
  }
}
