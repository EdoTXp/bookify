import 'dart:io';

import 'package:bookify/src/features/auth/bloc/auth_bloc.dart';
import 'package:bookify/src/features/auth/widgets/terms_informations.dart';
import 'package:bookify/src/features/root/views/root_page.dart';
import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/shared/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/shared/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_login_buttons/social_login_buttons.dart';

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
    _bloc = context.read<AuthBloc>();
    LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );
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
        SnackbarService.showSnackBar(
          context,
          'Agurade um estante',
          SnackBarType.info,
        );
        break;
      case AuthSignedState():
        SnackbarService.showSnackBar(
          context,
          'Autentificado com sucesso',
          SnackBarType.success,
        );
        Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            Navigator.of(context).pushReplacementNamed(
              RootPage.routeName,
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
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      bloc: _bloc,
      listener: _handleAuthStateListener,
      child: Scaffold(
        body: SafeArea(
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
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.google,
                    text: 'Entrar com o Google',
                    borderRadius: 44,
                    textColor: Colors.white,
                    backgroundColor: colorScheme.primary,
                    onPressed: () {
                      _bloc.add(
                        SignedInAuthEvent(
                          buttonType: 1,
                        ),
                      );
                    },
                  )
                else if (Platform.isIOS)
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.apple,
                    text: 'Entrar com a Apple',
                    borderRadius: 44,
                    textColor: Colors.white,
                    backgroundColor: colorScheme.primary,
                    onPressed: () {
                      _bloc.add(
                        SignedInAuthEvent(
                          buttonType: 2,
                        ),
                      );
                    },
                  ),
                const SizedBox(
                  height: 20,
                ),
                SocialLoginButton(
                  buttonType: SocialLoginButtonType.facebook,
                  text: 'Entrar com o Facebook',
                  borderRadius: 44,
                  textColor: Colors.white,
                  backgroundColor: colorScheme.primary,
                  onPressed: () {
                    _bloc.add(
                      SignedInAuthEvent(
                        buttonType: 3,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const TermsInformations(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
