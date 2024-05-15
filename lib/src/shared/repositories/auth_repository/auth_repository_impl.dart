import 'package:bookify/src/shared/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/shared/storage/storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Storage _storage;
  final String _userNameKey = 'userName';
  final String _userPhoto = 'userPhoto';

  const AuthRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<UserModel?> getUserModel() async {
    try {
      final userName = await _storage.getStorage(key: _userNameKey) as String?;
      final userPhoto = await _storage.getStorage(key: _userPhoto) as String?;

      if (userName == null) {
        return null;
      }

      final userModel = UserModel(
        name: userName,
        photo: userPhoto,
      );

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
      final userNameInserted = await _storage.insertStorage(
        key: _userNameKey,
        value: userModel.name,
      );
      final userPhotoInserted = await _storage.insertStorage(
        key: _userPhoto,
        value: userModel.photo ?? 'sem foto',
      );

      if (userNameInserted == 1 && userPhotoInserted == 1) {
        return 1;
      } else {
        return 0;
      }
    } on StorageException {
      rethrow;
    }
  }
}
