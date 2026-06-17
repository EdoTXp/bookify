import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

extension DatePickerDialogExtension on BuildContext {
  Future<DateTime?> showDateTimePicker({
    List<DateTime?> value = const [],
  }) async {
    final sizeOf = MediaQuery.sizeOf(this);
    final width = sizeOf.width * .90;
    final height = sizeOf.height * .40;

    final dateResult = await showCalendarDatePicker2Dialog(
      context: this,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        calendarViewMode: CalendarDatePicker2Mode.day,
        lastMonthIcon: Tooltip(
          message: 'previous-month-tooltip'.i18n(),
          child: const Icon(
            Icons.arrow_left,
          ),
        ),
        nextMonthIcon: Tooltip(
          message: 'next-month-tooltip'.i18n(),
          child: const Icon(
            Icons.arrow_right,
          ),
        ),
        calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
        centerAlignModePicker: true,
        firstDate: DateTime(DateTime.now().year - 1, 1, 1),
        lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      ),
      value: value,
      dialogSize: Size(
        width,
        height,
      ),
    );

    return dateResult?.first;
  }
}
