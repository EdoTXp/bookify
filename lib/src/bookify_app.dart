import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/blocs/user_theme_bloc/user_theme_bloc.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

class BookifyApp extends StatefulWidget {
  final FirebaseAuth auth;

  const BookifyApp({
    super.key,
    required this.auth,
  });

  @override
  State<BookifyApp> createState() => _BookifyAppState();
}

class _BookifyAppState extends State<BookifyApp> {
  late final UserThemeBloc _userThemeBloc;
  ThemeMode? _themeMode;
  bool userIsLogged = false;

  @override
  void initState() {
    super.initState();
    _userThemeBloc = context.read<UserThemeBloc>()
      ..add(
        GotUserThemeEvent(),
      );

    widget.auth.currentUser == null
        ? userIsLogged = false
        : userIsLogged = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForNotificationsOnInitializeApp();
    });
  }

  Future<void> _checkForNotificationsOnInitializeApp() async {
    final notificationService = context.read<NotificationsService>();
    await notificationService.checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    return BlocListener<UserThemeBloc, UserThemeState>(
      bloc: _userThemeBloc,
      listener: (context, state) {
        if (state is UserThemeLoadedState) {
          setState(() => _themeMode = state.themeMode);
        }
      },
      child: MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: _themeMode,
        navigatorKey: Routes.navigatorKey,
        routes: Routes.routes,
        initialRoute: Routes.getInitialRoute(userIsLogged),
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
      ),
    );
  }
}
