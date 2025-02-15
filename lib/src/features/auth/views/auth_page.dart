import 'dart:io';

import 'package:authentication_buttons/authentication_buttons.dart';
import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
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

class AuthPage extends StatefulWidget {
  /// The Route Name = '/auth'
  static const routeName = '/auth';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthBloc _bloc;
  bool showLoader = false;

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

  void _handleAuthStateListener(
    BuildContext context,
    AuthState state,
  ) {
    switch (state) {
      case AuthLoadingState():
        showLoader = true;
        SnackbarService.showSnackBar(
          context,
          'Aguarde um istante...',
          SnackBarType.info,
        );
        break;
      case AuthSignedState():
        showLoader = false;
        SnackbarService.showSnackBar(
          context,
          'Autentificado com sucesso.',
          SnackBarType.success,
        );
        Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
            if (context.mounted) {
              await Navigator.of(context).pushNamed(
                ReadingPageTimeCalculatorPage.routeName,
              );
            }

            if (context.mounted) {
              await Navigator.of(context).pushNamed(
                HourTimeCalculatorPage.routeName,
              );
            }

            if (context.mounted) {
              await Navigator.of(context).pushReplacementNamed(
                RootPage.routeName,
              );
            }
          },
        );
        break;
      case AuthErrorState():
        showLoader = false;
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
      body: BlocListener<AuthBloc, AuthState>(
        bloc: _bloc,
        listener: _handleAuthStateListener,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  BookifyImages.authLogo,
                  height: mediaQuerySizeOf.height * .5,
                  width: mediaQuerySizeOf.width,
                ),
                const Spacer(),
                if (Platform.isAndroid)
                  AuthenticationButton(
                    key: const Key('Google Button'),
                    authenticationMethod: AuthenticationMethod.google,
                    showLoader: showLoader,
                    onPressed: () {
                      _bloc.add(
                        SignedInAuthEvent(
                          signInTypeButton: SignInType.google,
                        ),
                      );
                    },
                  )
                else if (Platform.isIOS)
                  AuthenticationButton(
                    key: const Key('Apple Button'),
                    authenticationMethod: AuthenticationMethod.apple,
                    showLoader: showLoader,
                    onPressed: () {
                      _bloc.add(
                        SignedInAuthEvent(
                          signInTypeButton: SignInType.apple,
                        ),
                      );
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                AuthenticationButton(
                  key: const Key('Facebook Button'),
                  authenticationMethod: AuthenticationMethod.facebook,
                  showLoader: showLoader,
                  onPressed: () {
                    _bloc.add(
                      SignedInAuthEvent(
                        signInTypeButton: SignInType.facebook,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const TermsInformation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
