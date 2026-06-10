import 'package:bookify/src/core/helpers/error_code/auth_error_code/auth_error_code_extension.dart';
import 'package:bookify/src/core/helpers/error_code/platform_error_code/platform_error_code_extension.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/cubits/user_logged_cubit/user_logged_cubit.dart';
import 'package:bookify/src/shared/cubits/user_notification_cubit/user_notification_cubit.dart';
import 'package:bookify/src/shared/cubits/user_theme_cubit/user_theme_cubit.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:localization/localization.dart';

/// The root widget of the Bookify application.
///
/// Initializes global state management, theme configuration, and localization.
/// Coordinates multiple [Cubit]s ([UserThemeCubit], [UserLoggedCubit],
/// [UserNotificationCubit]) to manage application-wide settings and authentication status.
class BookifyApp extends StatefulWidget {
  /// Creates the root widget for the Bookify application.
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
    // Configure localization asset directories.
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    // Initialize global cubits for theme, authentication status, and notifications.
    context.read<UserLoggedCubit>().checkAuthStatus();
    context.read<UserThemeCubit>().getTheme();
    context.read<UserNotificationCubit>().initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically selects and updates the application's ThemeMode based on the UserThemeCubit state.
    return BlocSelector<UserThemeCubit, UserThemeState, ThemeMode>(
      selector: (state) => switch (state) {
        UserThemeLoadedState(:final themeMode) => themeMode,
        _ => ThemeMode.system,
      },
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Bookify',
          theme: AppTheme.appLightTheme,
          darkTheme: AppTheme.appDarkTheme,
          themeMode: themeMode,
          builder: (context, child) {
            final currentTheme = Theme.of(context);

            // Globally applies the appropriate system UI overlay style (status bar and navigation bar icon contrast)
            // matching the active light or dark theme context.
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: currentTheme.appBarTheme.systemOverlayStyle!,
              child: child!,
            );
          },
          navigatorKey: Routes.navigatorKey,
          routes: Routes.routes,
          home: MultiBlocListener(
            listeners: [
              // Listens for authentication failures to present localized error feedback.
              BlocListener<UserLoggedCubit, UserLoggedState>(
                listener: (context, state) {
                  if (state is UserLoggedErrorState) {
                    final errorCode = state.errorCode;
                    final errorDescriptionMessage =
                        state.errorDescriptionMessage;

                    SnackbarService.showSnackBar(
                      context,
                      errorCode.toLocalizedMessage(errorDescriptionMessage),
                      SnackBarType.error,
                    );
                  }
                },
              ),
              // Listens for notification initialization failures to present localized error feedback.
              BlocListener<UserNotificationCubit, UserNotificationState>(
                listener: (context, state) {
                  if (state is UserNotificationErrorState) {
                    final errorCode = state.errorCode;
                    final errorDescriptionMessage =
                        state.errorDescriptionMessage;

                    SnackbarService.showSnackBar(
                      context,
                      errorCode.toLocalizedMessage(errorDescriptionMessage),
                      SnackBarType.error,
                    );
                  }
                },
              ),
            ],
            // Selects the precise authentication flag to handle landing routing and splash dismissal.
            child: BlocSelector<UserLoggedCubit, UserLoggedState, bool?>(
              selector: (state) {
                return switch (state) {
                  UserLoggedLoadingState() => null,
                  UserLoggedLoadedState() => state.isLoggedIn,
                  UserLoggedErrorState() => false,
                };
              },
              builder: (context, isLoggedIn) {
                // Holds the native splash screen visible while computing user session parameters.
                if (isLoggedIn == null) {
                  return const Scaffold(
                    body: CenterCircularProgressIndicator(),
                  );
                }

                // Safely dismisses the native Android/iOS splash overlay exactly one frame after
                // the primary destination view has completely rendered to guarantee a seamless transition.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FlutterNativeSplash.remove();
                });
                return Routes.getInitialHome(isLoggedIn);
              },
            ),
          ),
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }

            // Defaults regional Portuguese variations to Brazilian Portuguese syntax.
            if (locale?.languageCode == 'pt') {
              return Locale('pt', 'BR');
            }

            // Default global standard fallback locale.
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
