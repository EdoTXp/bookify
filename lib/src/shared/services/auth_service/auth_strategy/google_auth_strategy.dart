import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthStrategy implements AuthStrategy {
  @override
  Future<UserModel> signIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final userModel = UserModel(
        name: userCredential.user?.displayName ?? 'Sem nome',
        photo: userCredential.user?.photoURL,
        signInType: SignInType.google,
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
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'With no message');
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }
}
