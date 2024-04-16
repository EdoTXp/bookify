import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DatePickerDialogService {
  static Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    List<DateTime?> value = const [],
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final sizeOf = MediaQuery.sizeOf(context);
    final width = sizeOf.width * .90;
    final height = sizeOf.height * .40;

    final dateResult = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        calendarViewMode: DatePickerMode.day,
        selectedDayHighlightColor: colorScheme.secondary,
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
