import 'package:bookify/src/core/helpers/date_time_format/date_time_format_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  final date = DateTime(2023, 10, 25);

  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('Test DateTime to String conversion ||', () {
    test('should format date for pt_BR locale', () {
      Intl.defaultLocale = 'pt_BR';
      final formattedDate = date.toFormattedDate();
      expect(formattedDate, '25/10/2023');
    });

    test('should format date for it_IT locale', () {
      Intl.defaultLocale = 'it_IT';
      final formattedDate = date.toFormattedDate();
      expect(formattedDate, '25/10/2023');
    });

    test('should format date for en_US locale', () {
      Intl.defaultLocale = 'en_US';
      final formattedDate = date.toFormattedDate();
      expect(formattedDate, '10/25/2023');
    });

    test('should format date with custom format', () {
      final formattedDate = date.toFormattedDate('yyyy-MM-dd');
      expect(formattedDate, '2023-10-25');
    });
  });

  group('Test String to DateTime conversion ||', () {
    test('should parse date for pt_BR locale', () {
      Intl.defaultLocale = 'pt_BR';
      const dateString = '25/10/2023';
      final parsedDate = dateString.parseFormattedDate();
      expect(parsedDate, date);
    });

    test('should parse date for it_IT locale', () {
      Intl.defaultLocale = 'it_IT';
      const dateString = '25/10/2023';
      final parsedDate = dateString.parseFormattedDate();
      expect(parsedDate, date);
    });

    test('should parse date for en_US locale', () {
      Intl.defaultLocale = 'en_US';
      const dateString = '10/25/2023';
      final parsedDate = dateString.parseFormattedDate();
      expect(parsedDate, date);
    });

    test('should parse date with custom format', () {
      const dateString = '2023-10-25';
      final parsedDate = dateString.parseFormattedDate('yyyy-MM-dd');
      expect(parsedDate, date);
    });
  });

  test('should throw FormatException for invalid date string', () {
    Intl.defaultLocale = 'pt_BR';
    const invalidDateString = '2023-10-25';
    expect(
      () => invalidDateString.parseFormattedDate(),
      throwsA(isA<FormatException>()),
    );
  });

  test('should throw FormatException for completely wrong format', () {
    const invalidDateString = 'not a date';
    expect(
      () => invalidDateString.parseFormattedDate(),
      throwsA(isA<FormatException>()),
    );
  });
}
