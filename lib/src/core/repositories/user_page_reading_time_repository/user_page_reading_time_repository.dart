import 'package:bookify/src/core/models/user_page_reading_time.dart';

abstract interface class UserPageReadingTimeRepository {
  Future<UserPageReadingTime> getUserPageReadingTime();
  Future<int> setUserPageReadingTime({
    required UserPageReadingTime userPageReadingTime,
  });
}
