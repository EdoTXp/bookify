import 'package:intl/intl.dart';

/// An extension on [DateTime] to format dates into a specified string format.
///
/// This extension provides a convenient way to format [DateTime] instances
/// into a string representation according to a given format.
/// The default format is 'dd/MM/yyyy', but it can be customized.
extension DateTimeFormatExtension on DateTime {
  /// Formats this [DateTime] instance into a string using the specified [dateFormat].
  ///
  /// Returns a string representation of this [DateTime] in the format specified by [dateFormat].
  /// If no [dateFormat] is provided, it defaults to 'dd/MM/yyyy'.
  String toFormattedDate([String dateFormat = 'dd/MM/yyyy']) =>
      DateFormat(dateFormat).format(this);
}

/// An extension on [String] to parse dates from a formatted string.
///
/// This extension allows parsing a date from a string that is formatted
/// according to a specified pattern. The default pattern is 'dd/MM/yyyy'.
extension StringDateTime on String {
  /// Parses this string into a [DateTime] object using the specified [dateFormat].
  ///
  /// Returns a [DateTime] object parsed from this string using the format specified by [dateFormat].
  /// If no [dateFormat] is provided, it defaults to 'dd/MM/yyyy'.
  DateTime parseFormattedDate([String dateFormat = 'dd/MM/yyyy']) {
    return DateFormat(dateFormat).parse(this);
  }
}
