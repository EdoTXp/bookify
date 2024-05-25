import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test UserPageReadingTime model class', () {
    test('readingTimeForTotalBookPage', () {
      const time = UserPageReadingTimeModel(
        pageReadingTimeSeconds: 120, // 2 minutes
      );

      final totalPagesInHour = time.readingTimeForTotalBookPage(300);

      expect(
        totalPagesInHour,
        equals(10),
      );
    });
  });
}
