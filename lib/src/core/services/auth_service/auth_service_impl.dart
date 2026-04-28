import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'auth_strategy/auth_strategy_factory.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepository _authRepository;
  final AuthStrategyFactory _authStrategyFactory;

  const AuthServiceImpl({
    required AuthRepository authRepository,
    required AuthStrategyFactory authStrategyFactory,
  }) : _authRepository = authRepository,
       _authStrategyFactory = authStrategyFactory;

  @override
  Future<bool> userIsLoggedIn() async {
    final userIsLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (!userIsLoggedIn) {
      await _authRepository.deleteUserModel();
      return false;
    }
    return true;
  }

  @override
  Future<int> signIn({required SignInType signInType}) async {
    try {
      final authStrategy = _authStrategyFactory.create(signInType);

      final userModel = await authStrategy.signIn();
      final userInserted = await _authRepository.setUserModel(
        userModel: userModel,
      );

      return userInserted;
    } on AuthException {
      rethrow;
    } on StorageException catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.descriptionMessage,
      );
    } on Exception catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<bool> signOut({required SignInType signInType}) async {
    try {
      final authStrategy = _authStrategyFactory.create(signInType);
      final strategyResult = await authStrategy.signOut();

      if (strategyResult) {
        await _authRepository.deleteUserModel();
      }
      return strategyResult;
    } on AuthException {
      rethrow;
    } on StorageException catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.descriptionMessage,
      );
    } on Exception catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<UserModel?> getUserModel() async {
    try {
      final user = await _authRepository.getUserModel();
      return user;
    } on StorageException catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.descriptionMessage,
      );
    } on Exception catch (e) {
      throw AuthException(
        AuthErrorCode.internalError,
        descriptionMessage: e.toString(),
      );
    }
  }
}
