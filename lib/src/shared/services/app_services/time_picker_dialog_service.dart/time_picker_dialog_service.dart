import 'package:flutter/material.dart';

class TimePickerDialogService {
  static Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      helpText: 'Selecione Horas e Minutos',
      hourLabelText: 'Horas',
      minuteLabelText: 'Minutos',
      errorInvalidText: 'Burro',
      confirmText: 'CONFIRMAR',
    );

    return selectedTime;
  }
}
