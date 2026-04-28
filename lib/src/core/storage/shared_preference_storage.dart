import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookify/src/core/storage/storage.dart';

class SharedPreferencesStorage implements Storage {
  @override
  Future<Object?> getStorage({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final storageValue = sharedPreferences.get(key);
      return storageValue;
    } on StorageException {
      rethrow;
    } catch (e) {
      throw StorageException(
        StorageErrorCode.readFailed,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<int> insertStorage({
    required String key,
    required Object value,
  }) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final storageInserted = switch (value.runtimeType) {
        const (int) => await sharedPreferences.setInt(
          key,
          value as int,
        ),
        const (String) => await sharedPreferences.setString(
          key,
          value as String,
        ),
        const (bool) => await sharedPreferences.setBool(
          key,
          value as bool,
        ),
        const (double) => await sharedPreferences.setDouble(
          key,
          value as double,
        ),
        const (List<String>) => await sharedPreferences.setStringList(
          key,
          value as List<String>,
        ),
        _ => throw StorageException(
          StorageErrorCode.invalidValue,
          descriptionMessage: 'Unsupported type: ${value.runtimeType}',
        ),
      };

      return storageInserted == true ? 1 : 0;
    } catch (e) {
      if (e is StorageException) rethrow;

      throw StorageException(
        StorageErrorCode.writeFailed,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<bool> existsStorage({required String key}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<int> getKeysCount() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getKeys().length;
  }

  @override
  Future<int> deleteStorage({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final deletedStorage = await sharedPreferences.remove(key);
      return deletedStorage == true ? 1 : 0;
    } catch (e) {
      throw StorageException(
        StorageErrorCode.writeFailed,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<int> deleteAllStorage() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final clearStorage = await sharedPreferences.clear();
      return clearStorage == true ? 1 : 0;
    } catch (e) {
      throw StorageException(
        StorageErrorCode.writeFailed,
        descriptionMessage: e.toString(),
      );
    }
  }
}
