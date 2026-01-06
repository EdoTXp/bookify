import 'dart:io';

import 'package:authentication_buttons/authentication_buttons.dart';
import 'package:flutter/material.dart';

class PlatformSignInButtons extends StatelessWidget {
  final bool showLoader;
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;

  const PlatformSignInButtons({
    super.key,
    required this.showLoader,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (Platform.isAndroid)
          AuthenticationButton(
            key: const Key('GoogleButton'),
            authenticationMethod: AuthenticationMethod.google,
            showLoader: showLoader,
            onPressed: onGooglePressed,
          )
        else if (Platform.isIOS)
          AuthenticationButton(
            key: const Key('AppleButton'),
            authenticationMethod: AuthenticationMethod.apple,
            showLoader: showLoader,
            onPressed: onApplePressed,
          ),
        const SizedBox(height: 20),
        AuthenticationButton(
          key: const Key('FacebookButton'),
          authenticationMethod: AuthenticationMethod.facebook,
          showLoader: showLoader,
          onPressed: onFacebookPressed,
        ),
      ],
    );
  }
}
