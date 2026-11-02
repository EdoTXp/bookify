import 'package:bookify/src/core/enums/app_theme_mode.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/data/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:bookify/src/data/storage/storage.dart';

class UserThemeRepositoryImpl implements UserThemeRepository {
  final Storage _storage;
  final String _themeKey = 'theme';

  const UserThemeRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<AppThemeMode> getThemeMode() async {
    try {
      final themeCode = await _storage.getStorage(key: _themeKey) as int?;
      return AppThemeMode.fromCode(themeCode);
    } on TypeError {
      throw const StorageException(
        StorageErrorCode.invalidValue,
        descriptionMessage: 'Impossible to convert theme mode.',
      );
    } on StorageException {
      rethrow;
    }
  }

  @override
  Future<int> setThemeMode({required AppThemeMode appThemeMode}) async {
    try {
      final themeInserted = await _storage.insertStorage(
        key: _themeKey,
        value: appThemeMode.themeCode,
      );
      return themeInserted;
    } on StorageException {
      rethrow;
    } catch (e) {
      throw StorageException(
        StorageErrorCode.writeFailed,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<int> deleteThemeMode() async {
    try {
      return await _storage.deleteStorage(key: _themeKey);
    } on StorageException {
      rethrow;
    } catch (e) {
      throw StorageException(
        StorageErrorCode.writeFailed,
        descriptionMessage: e.toString(),
      );
    }
  }
}
