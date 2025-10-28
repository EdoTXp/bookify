import 'package:intl/intl.dart';

/// An extension on [double] to format the number according to a locale and decimal digits.
extension LocaleDecimalFormatExtension on double {
  /// Formats the current double value to a locale-specific decimal format.
  ///
  /// By default, it uses the app's current locale.
  /// A custom [locale] and the number of [decimalDigits] can be provided
  /// to override the default behavior, which is useful for testing.
  ///
  /// Returns a string representation of the number formatted according to the specified locale and decimal digits.
  String toLocaleDecimalFormat({
    String? locale,
    int? decimalDigits,
  }) {
    final localeFormat = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );

    return localeFormat.format(this);
  }
}
