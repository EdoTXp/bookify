import 'package:bookify/src/shared/cubits/user_logged_cubit/user_logged_cubit.dart';
import 'package:bookify/src/shared/cubits/user_notification_cubit/user_notification_cubit.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

class BookifyApp extends StatefulWidget {
  const BookifyApp({
    super.key,
  });

  @override
  State<BookifyApp> createState() => _BookifyAppState();
}

class _BookifyAppState extends State<BookifyApp> {
  @override
  void initState() {
    super.initState();

    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    context.read<UserThemeCubit>().getTheme();
    context.read<UserLoggedCubit>().checkAuthStatus();
    context.read<UserNotificationCubit>().initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<UserThemeCubit, ThemeMode>(
      (cubit) => switch (cubit.state) {
        UserThemeLoadedState(:final themeMode) => themeMode,
        _ => ThemeMode.system,
      },
    );

    final isLoggedIn = context.select<UserLoggedCubit, bool>(
      (cubit) =>
          cubit.state is UserLoggedLoadedState &&
          (cubit.state as UserLoggedLoadedState).isLoggedIn,
    );

    return MaterialApp(
      title: 'Bookify',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      navigatorKey: Routes.navigatorKey,
      routes: Routes.routes,
      initialRoute: Routes.getInitialRoute(isLoggedIn),
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        if (locale?.languageCode == 'pt') {
          return Locale('pt', 'BR');
        }

        return Locale('en', 'US');
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
        Locale('it', 'IT'),
      ],
    );
  }
}
