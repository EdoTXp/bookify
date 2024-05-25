import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/core/storage/storage.dart';

class UserHourTimeRepositoryImpl implements UserHourTimeRepository {
  final Storage _storage;
  final String _userHourTimeKey = 'userHourTime';

  const UserHourTimeRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<UserHourTimeModel?> getUserHourTime() async {
    try {
      final userHourTimeJson = await _storage.getStorage(
        key: _userHourTimeKey,
      ) as String?;

      if (userHourTimeJson == null) {
        return null;
      }

      final userReadingTimeModel = UserHourTimeModel.fromJson(userHourTimeJson);

      return userReadingTimeModel;
    } on TypeError {
      throw const StorageException('impossível converter a hora de leitura.');
    } on StorageException {
      rethrow;
    }
  }

  @override
  Future<int> setUserHourTime({
    required UserHourTimeModel userHourTime,
  }) async {
    try {
      final userHourTimeJsonInserted = await _storage.insertStorage(
        key: _userHourTimeKey,
        value: userHourTime.toJson(),
      );

      return (userHourTimeJsonInserted == 1) ? 1 : 0;
    } on StorageException {
      rethrow;
    }
  }
}
