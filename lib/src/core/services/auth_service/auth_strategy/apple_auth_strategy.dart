import 'dart:convert';
import 'dart:math';

import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthStrategy implements AuthStrategy {
  final FirebaseAuth _firebaseAuth;

  AppleAuthStrategy({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
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

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );

      final userModel = UserModel(
        name: userCredential.user?.displayName,
        photo: userCredential.user?.photoURL,
        signInType: SignInType.apple,
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      final errorCode = switch (e.code) {
        'user-not-found' => AuthErrorCode.userNotFound,
        'wrong-password' => AuthErrorCode.wrongPassword,
        'invalid-email' => AuthErrorCode.invalidEmail,
        'account-disabled' => AuthErrorCode.accountDisabled,
        'too-many-requests' => AuthErrorCode.tooManyRequests,
        'operation-not-allowed' => AuthErrorCode.operationNotAllowed,
        'network-request-failed' => AuthErrorCode.networkRequestFailed,
        _ => AuthErrorCode.internalError,
      };
      throw AuthException(
        errorCode,
        descriptionMessage: e.message,
      );
    } on AuthException {
      rethrow;
    } on Exception catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.message ?? 'Sign out failed',
      );
    } on Exception catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.toString(),
      );
    }
  }
}
