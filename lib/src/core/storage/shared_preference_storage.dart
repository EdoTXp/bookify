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
    } catch (e) {
      throw StorageException(e.toString());
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
            'Type of value not valid: ${value.runtimeType}',
          ),
      };

      return storageInserted == true ? 1 : 0;
    } catch (e) {
      throw StorageException(e.toString());
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
      throw StorageException(e.toString());
    }
  }

  @override
  Future<int> deleteAllStorage() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final clearStorage = await sharedPreferences.clear();
      return clearStorage == true ? 1 : 0;
    } catch (e) {
      throw StorageException(e.toString());
    }
  }
}
