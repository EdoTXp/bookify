import 'package:bookify/src/shared/errors/storage_exception/storage_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookify/src/shared/storage/storage.dart';

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
  Future<int> insertStorage({required String key, Object? value}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      final int storageInserted;

      switch (value.runtimeType) {
        case const (int):
          storageInserted = await sharedPreferences.setInt(
                    key,
                    value as int,
                  ) ==
                  true
              ? 1
              : 0;
          break;

        case const (String):
          storageInserted = await sharedPreferences.setString(
                    key,
                    value as String,
                  ) ==
                  true
              ? 1
              : 0;
          break;

        case const (bool):
          storageInserted = await sharedPreferences.setBool(
                    key,
                    value as bool,
                  ) ==
                  true
              ? 1
              : 0;
          break;

        case const (double):
          storageInserted = await sharedPreferences.setDouble(
                    key,
                    value as double,
                  ) ==
                  true
              ? 1
              : 0;
          break;

        case const (List<String>):
          storageInserted = await sharedPreferences.setStringList(
                    key,
                    value as List<String>,
                  ) ==
                  true
              ? 1
              : 0;
          break;

        default:
          throw StorageException(
              'Type of value not valid: ${value.runtimeType}');
      }

      return storageInserted;
    } catch (e) {
      throw StorageException(e.toString());
    }
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
