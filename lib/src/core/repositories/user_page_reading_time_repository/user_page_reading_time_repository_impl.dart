import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:bookify/src/core/storage/storage.dart';

class UserPageReadingTimeRepositoryImpl
    implements UserPageReadingTimeRepository {
  final Storage _storage;
  final String _userPageReadingTimeKey = 'userPageReadingTime';

  const UserPageReadingTimeRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<UserPageReadingTimeModel> getUserPageReadingTime() async {
    try {
      final pageReading =
          await _storage.getStorage(
                key: _userPageReadingTimeKey,
              )
              as int?;

      final userPageReadingTime = UserPageReadingTimeModel(
        pageReadingTimeSeconds: pageReading,
      );

      return userPageReadingTime;
    } on TypeError {
      throw const StorageException(
        StorageErrorCode.invalidValue,
        descriptionMessage: 'Impossible to convert user page reading time.',
      );
    } on StorageException {
      rethrow;
    }
  }

  @override
  Future<int> setUserPageReadingTime({
    required UserPageReadingTimeModel userPageReadingTime,
  }) async {
    try {
      final userPageReadingTimeInserted = await _storage.insertStorage(
        key: _userPageReadingTimeKey,
        value: userPageReadingTime.pageReadingTimeSeconds!,
      );

      return userPageReadingTimeInserted;
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
