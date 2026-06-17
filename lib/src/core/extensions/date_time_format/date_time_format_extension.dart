import 'package:intl/intl.dart';

/// An extension on [DateTime] to format dates into a string.
///
/// This extension provides a convenient way to format [DateTime] instances
/// into a string representation. By default, it uses the locale-specific
/// date format.
extension DateTimeFormatExtension on DateTime {
  /// Formats this [DateTime] instance into a string.
  ///
  /// By default, it uses the locale-specific date format (e.g., 'dd/MM/yyyy' for Italian).
  /// A custom [dateFormat] pattern can be provided to override the default behavior,
  /// which is useful for testing.
  String toFormattedDate([String? dateFormat]) {
    final formatter = dateFormat != null
        ? DateFormat(dateFormat)
        : DateFormat.yMd();
    return formatter.format(this);
  }
}

/// An extension on [String] to parse dates from a formatted string.
///
/// This extension allows parsing a date from a string that is formatted
/// according to the locale-specific date format by default.
extension StringDateTime on String {
  /// Parses this string into a [DateTime] object.
  ///
  /// By default, it uses the locale-specific date format for parsing.
  /// A custom [dateFormat] pattern can be provided to override the default behavior,
  /// which is useful for testing.
  DateTime parseFormattedDate([String? dateFormat]) {
    final formatter = dateFormat != null
        ? DateFormat(dateFormat)
        : DateFormat.yMd();
    return formatter.parse(this);
  }
}
