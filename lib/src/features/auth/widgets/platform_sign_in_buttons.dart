import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:sign_in_button/sign_in_button.dart';

class PlatformSignInButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;

  const PlatformSignInButtons({
    super.key,
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
          SignInButton(
            key: const Key('GoogleButton'),
            Buttons.googleDark,
            onPressed: onGooglePressed,
            text: 'sign-in-google-button'.i18n(),
          )
        else if (Platform.isIOS)
          SignInButton(
            key: const Key('AppleButton'),
            Buttons.apple,
            onPressed: onApplePressed,
            text: 'sign-in-apple-button'.i18n(),
          ),
        SignInButton(
          key: const Key('FacebookButton'),
          Buttons.facebookNew,
          onPressed: onFacebookPressed,
          text: 'sign-in-facebook-button'.i18n(),
        ),
      ],
    );
  }
}
