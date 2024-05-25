import 'package:bookify/src/core/models/user_page_reading_time_model.dart';

abstract interface class UserPageReadingTimeRepository {
  Future<UserPageReadingTimeModel> getUserPageReadingTime();
  Future<int> setUserPageReadingTime({
    required UserPageReadingTimeModel userPageReadingTime,
  });
}
