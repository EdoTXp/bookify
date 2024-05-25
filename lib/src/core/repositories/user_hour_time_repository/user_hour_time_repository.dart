import 'package:bookify/src/core/models/user_hour_time_model.dart';

abstract interface class UserHourTimeRepository {
  Future<UserHourTimeModel?> getUserHourTime();
  Future<int> setUserHourTime({required UserHourTimeModel userHourTime});
}
