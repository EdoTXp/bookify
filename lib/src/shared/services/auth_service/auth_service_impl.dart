import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/apple_auth_strategy.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/auth_strategy_manager.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/facebook_auth_strategy.dart';
import 'package:bookify/src/shared/services/auth_service/auth_strategy/google_auth_strategy.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;

  const AuthServiceImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<int> signIn({required SignInType signInType}) async {
    try {
      final AuthStrategyManager authStrategyManager;
      switch (signInType) {
        case SignInType.google:
          authStrategyManager = AuthStrategyManager(
            authStrategy: GoogleAuthStrategy(),
          );
          break;
        case SignInType.facebook:
          authStrategyManager = AuthStrategyManager(
            authStrategy: FacebookAuthStrategy(),
          );
          break;
        case SignInType.apple:
          authStrategyManager = AuthStrategyManager(
            authStrategy: AppleAuthStrategy(),
          );
          break;
      }

      final userModel = await authStrategyManager.signIn();
      final userInserted =
          await _authRepository.setUserModel(userModel: userModel);

      return userInserted;
    } on AuthException {
      rethrow;
    }
  }

  @override
  Future<bool> signOut({required SignInType signInType}) async {
    try {
      return switch (signInType) {
        SignInType.google => await AuthStrategyManager(
            authStrategy: GoogleAuthStrategy(),
          ).signOut(),
        SignInType.facebook => await AuthStrategyManager(
            authStrategy: FacebookAuthStrategy(),
          ).signOut(),
        SignInType.apple => await AuthStrategyManager(
            authStrategy: AppleAuthStrategy(),
          ).signOut(),
      };
    } on AuthException {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUserModel() async {
    try {
      final user = await _authRepository.getUserModel();
      return user;
    } on AuthException {
      rethrow;
    } on StorageException {
      rethrow;
    }
  }
}
