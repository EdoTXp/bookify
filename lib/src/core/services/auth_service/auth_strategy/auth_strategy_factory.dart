import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'apple_auth_strategy.dart';
import 'auth_strategy.dart';
import 'facebook_auth_strategy.dart';
import 'google_auth_strategy.dart';

class AuthStrategyFactory {
  AuthStrategy create(SignInType signInType) {
    return switch (signInType) {
      SignInType.google => GoogleAuthStrategy(
          googleSignIn: GoogleSignIn.instance,
          firebaseAuth: FirebaseAuth.instance,
        ),
      SignInType.apple => AppleAuthStrategy(
          firebaseAuth: FirebaseAuth.instance,
        ),
      SignInType.facebook => FacebookAuthStrategy(
          facebookAuth: FacebookAuth.instance,
          firebaseAuth: FirebaseAuth.instance,
        ),
    };
  }
}
