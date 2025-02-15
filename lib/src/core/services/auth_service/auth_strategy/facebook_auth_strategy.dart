import 'dart:convert';
import 'dart:math';

import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthStrategy implements AuthStrategy {
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserModel> signIn() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final loginResult = await FacebookAuth.instance.login(
        nonce: nonce,
      );

      if (loginResult.status == LoginStatus.success) {
        OAuthCredential facebookOAuthCredential;

        if (loginResult.accessToken!.type == AccessTokenType.limited) {
          facebookOAuthCredential = OAuthProvider('facebook.com').credential(
            idToken: loginResult.accessToken!.tokenString,
            rawNonce: rawNonce,
          );
        } else {
          facebookOAuthCredential = FacebookAuthProvider.credential(
            loginResult.accessToken!.tokenString,
          );
        }

        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          facebookOAuthCredential,
        );

        final userModel = UserModel(
          name: userCredential.user?.displayName ?? 'Sem nome',
          photo: userCredential.user?.photoURL,
          signInType: SignInType.facebook,
        );

        return userModel;
      }

      throw const AuthException('O usuário não autorizou a autentificação');
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'With no message');
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'With no message');
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }
}
