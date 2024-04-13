import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class DatePickerDialogService {
  static Future<List<DateTime?>?> showDateTimePickerRange({
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
        calendarType: CalendarDatePicker2Type.range,
        calendarViewMode: DatePickerMode.day,
        selectedDayHighlightColor: colorScheme.secondary,
        calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
        disableModePicker: true,
        firstDate: DateTime(DateTime.now().year, 1, 1),
        lastDate: DateTime(DateTime.now().year, 12, 31),
      ),
      value: value,
      dialogSize: Size(
        width,
        height,
      ),
    );

    if (dateResult != null) {
      final lastDate = dateResult.last?.millisecondsSinceEpoch;
      final firsData = dateResult.first?.millisecondsSinceEpoch;

      if (lastDate != null && firsData != null) {
        if (lastDate > firsData) {
          return dateResult;
        }
      }
    }
    
    return null;
  }
}
