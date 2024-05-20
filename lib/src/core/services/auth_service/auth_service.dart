import 'package:bookify/src/core/models/user_model.dart';

abstract interface class AuthService {
  Future<int> signIn({required SignInType signInType});
  Future<bool> signOut({required SignInType signInType});
  Future<UserModel?> getUserModel();
}
