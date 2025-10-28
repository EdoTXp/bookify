import 'package:bookify/src/core/helpers/locale_decimal_format/locale_decimal_format_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  const number = 1234.56;

  setUpAll(() async {
    await initializeDateFormatting('pt_BR', null);
    await initializeDateFormatting('it_IT', null);
    await initializeDateFormatting('en_US', null);
  });

  group('Test double to locale-specific String conversion ||', () {
    test('should format number for pt_BR locale with default decimal digits',
        () {
      Intl.defaultLocale = 'pt_BR';
      final formattedNumber = number.toLocaleDecimalFormat();
      expect(formattedNumber, '1.234,56');
    });

    test('should format number for it_IT locale with 2 decimal digits', () {
      final formattedNumber = number.toLocaleDecimalFormat(
        locale: 'it_IT',
        decimalDigits: 2,
      );
      expect(formattedNumber, '1.234,56');
    });

    test('should format number for en_US locale with 1 decimal digit', () {
      final formattedNumber = number.toLocaleDecimalFormat(
        locale: 'en_US',
        decimalDigits: 1,
      );

      expect(formattedNumber, '1,234.6');
    });

    test('should format number for en_US locale with 4 decimal digits', () {
      final formattedNumber = number.toLocaleDecimalFormat(
        locale: 'en_US',
        decimalDigits: 4,
      );

      expect(formattedNumber, '1,234.5600');
    });
  });
}
