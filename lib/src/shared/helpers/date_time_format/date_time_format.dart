import 'package:intl/intl.dart';

extension DateTimeFormatExtension on DateTime {
  String toFormattedDate([String dateFormat = 'dd/MM/yyyy']) =>
      DateFormat(dateFormat).format(this);
}

extension StringDateTime on String {
  DateTime parseFormattedDate([String dateFormat = 'dd/MM/yyyy']) {
    return DateFormat(dateFormat).parse(this);
  }
}
