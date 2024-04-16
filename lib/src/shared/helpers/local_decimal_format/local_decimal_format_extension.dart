import 'package:intl/intl.dart';

/// An extension on [double] to format the number according to a locale and decimal digits.
extension LocaleDecimalFormatExtension on double {
  /// Formats the current double value to a locale-specific decimal format.
  ///
  /// [locale] specifies the locale to use for formatting. Defaults to 'pt-BR'.
  /// [decimalDigits] specifies the number of digits after the decimal point. Defaults to 1.
  ///
  /// Returns a string representation of the number formatted according to the specified locale and decimal digits.
  String toLocaleDecimalFormat(
      [String locale = 'pt-BR', int decimalDigits = 1]) {
    final localeFormat = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );

    return localeFormat.format(this);
  }
}
