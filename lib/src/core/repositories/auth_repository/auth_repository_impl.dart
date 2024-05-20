import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/core/storage/storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Storage _storage;
  final String _userKey = 'user';

  const AuthRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<UserModel?> getUserModel() async {
    try {
      final userJson = await _storage.getStorage(
        key: _userKey,
      ) as String?;

      if (userJson == null) {
        return null;
      }

      final userModel = UserModel.fromJson(userJson);

      return userModel;
    } on TypeError {
      throw const StorageException('impossível converter o usuário.');
    } on StorageException {
      rethrow;
    }
  }

  @override
  Future<int> setUserModel({required UserModel userModel}) async {
    try {
      final userJsonInserted = await _storage.insertStorage(
        key: _userKey,
        value: userModel.toJson(),
      );

      return (userJsonInserted == 1) ? 1 : 0;
    } on StorageException {
      rethrow;
    }
  }
}
