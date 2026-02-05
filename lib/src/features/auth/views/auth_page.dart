import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
import 'package:bookify/src/features/auth/widgets/platform_sign_in_buttons.dart';
import 'package:bookify/src/features/auth/widgets/terms_information.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/reading_page_time_calculator_page.dart';
import 'package:bookify/src/features/hour_time_calculator/views/hour_time_calculator_page.dart';
import 'package:bookify/src/features/root/views/root_page.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/core/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class AuthPage extends StatefulWidget {
  /// The Route Name = '/auth'
  static const routeName = '/auth';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthBloc _bloc;

  @override
  void initState() {
    super.initState();
    LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );
    _bloc = context.read<AuthBloc>();
  }

  @override
  void dispose() {
    LockScreenOrientationService.unLockOrientationScreen();
    super.dispose();
  }

  void _handleAuthStateListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthInitialState():
        break;
      case AuthLoadingState():
        SnackbarService.showSnackBar(
          context,
          'wait-snackbar'.i18n(),
          SnackBarType.info,
        );
        break;
      case AuthSignedState():
        SnackbarService.showSnackBar(
          context,
          'auth-success-snackbar'.i18n(),
          SnackBarType.success,
        );
        Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
            if (!context.mounted) return;
            await Navigator.of(context).pushNamed(
              ReadingPageTimeCalculatorPage.routeName,
            );

            if (!context.mounted) return;
            await Navigator.of(context).pushNamed(
              HourTimeCalculatorPage.routeName,
            );

            if (!context.mounted) return;
            await Navigator.of(context).pushNamedAndRemoveUntil(
              RootPage.routeName,
              (route) => false,
            );
          },
        );
        break;
      case AuthErrorState():
        SnackbarService.showSnackBar(
          context,
          state.errorMessage,
          SnackBarType.error,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                key: const Key('BookifyLogoImage'),
                BookifyImages.authLogo,
                height: mediaQuerySizeOf.height * .5,
                width: mediaQuerySizeOf.width,
              ),
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                bloc: _bloc,
                listener: _handleAuthStateListener,
                builder: (context, state) {
                  return PlatformSignInButtons(
                    showLoader: state is AuthLoadingState,
                    onGooglePressed: () => _bloc.add(
                      SignedInAuthEvent(
                        signInTypeButton: SignInType.google,
                      ),
                    ),
                    onApplePressed: () => _bloc.add(
                      SignedInAuthEvent(
                        signInTypeButton: SignInType.apple,
                      ),
                    ),
                    onFacebookPressed: () => _bloc.add(
                      SignedInAuthEvent(
                        signInTypeButton: SignInType.facebook,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const TermsInformation(),
            ],
          ),
        ),
      ),
    );
  }
}
