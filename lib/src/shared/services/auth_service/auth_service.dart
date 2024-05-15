import 'package:bookify/src/shared/models/user_model.dart';

enum SignInType {
  google,
  facebook,
  apple;
}

abstract interface class AuthService {
  Future<int> signIn({required SignInType signInType});
  Future<bool> signOut({required SignInType signInType});
  Future<UserModel?> getUserModel();
}
