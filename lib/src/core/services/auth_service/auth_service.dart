import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';

abstract interface class AuthService {
  Future<int> signIn({required SignInType signInType});
  Future<bool> signOut({required SignInType signInType});
  Future<UserModel?> getUserModel();
}
