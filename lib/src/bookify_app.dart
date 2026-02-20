import 'dart:async';

import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late final UserThemeCubit _userThemeCubit;

  @override
  void initState() {
    super.initState();
    _userThemeCubit = context.read<UserThemeCubit>()..getTheme();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkForNotificationsOnInitializeApp(),
    );
  }

  void _checkForNotificationsOnInitializeApp() {
    final notificationService = context.read<NotificationsService>();
    unawaited(notificationService.checkForNotifications());
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    return BlocBuilder<UserThemeCubit, UserThemeState>(
      bloc: _userThemeCubit,
      builder: (context, state) {
        final themeMode = switch (state) {
          UserThemeLoadedState(:final themeMode) => themeMode,
          _ => ThemeMode.system,
        };

        return MaterialApp(
          title: 'Bookify',
          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode: themeMode,
          navigatorKey: Routes.navigatorKey,
          routes: Routes.routes,
          initialRoute: Routes.getInitialRoute(
            FirebaseAuth.instance.currentUser != null,
          ),
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
      },
    );
  }
}
