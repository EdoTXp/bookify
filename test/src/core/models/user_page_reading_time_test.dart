import 'package:bookify/src/core/models/user_page_reading_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test UserPageReadingTime model class', () {
    test('readingTimeForTotalBookPage', () {
      const time = UserPageReadingTime(
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
