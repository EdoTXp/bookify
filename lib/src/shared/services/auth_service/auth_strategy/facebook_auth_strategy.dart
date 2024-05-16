import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthStrategy implements AuthStrategy {
  @override
  Future<UserModel> signIn() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential,
      );

      final userModel = UserModel(
        name: userCredential.user?.displayName ?? 'Sem nome',
        photo: userCredential.user?.photoURL,
        signInType: SignInType.facebook,
      );

      return userModel;
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
