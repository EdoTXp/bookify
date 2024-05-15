import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/auth_strategy.dart';

class AuthStrategyManager {
  final AuthStrategy authStrategy;

  const AuthStrategyManager({
    required this.authStrategy,
  });

  Future<UserModel> signIn() async {
    try {
      final user = await authStrategy.signIn();
      return user;
    } on AuthException {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      final userLogout = await authStrategy.signOut();
      return userLogout;
    } on AuthException {
      rethrow;
    }
  }
}
