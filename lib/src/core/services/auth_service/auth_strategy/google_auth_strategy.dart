import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/services/auth_service/auth_strategy/auth_strategy.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthStrategy implements AuthStrategy {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  GoogleAuthStrategy({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
  })  : _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  @override
  Future<UserModel> signIn() async {
    try {
      await _googleSignIn.initialize().onError(
            (error, _) => throw AuthException(error.toString()),
          );

      const scopes = ['https://www.googleapis.com/auth/contacts.readonly'];

      final googleAuth = await _googleSignIn.authenticate();
      final authorization =
          await googleAuth.authorizationClient.authorizationForScopes(scopes);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.authentication.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final userModel = UserModel(
        name: userCredential.user?.displayName,
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
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'With no message');
    } on Exception catch (e) {
      throw AuthException(e.toString());
    }
  }
}
