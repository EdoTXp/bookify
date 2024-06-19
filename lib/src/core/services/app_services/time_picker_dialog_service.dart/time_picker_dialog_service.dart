import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerDialogService {
  static Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, [
    TimeOfDay? initialTime,
  ]) async {
    TimeOfDay? selectedTime;

    if (Platform.isAndroid) {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: initialTime ?? const TimeOfDay(hour: 0, minute: 0),
        helpText: 'Selecione Horas e Minutos',
        hourLabelText: 'Horas',
        minuteLabelText: 'Minutos',
        errorInvalidText: 'Impossível recuperar o tempo',
        cancelText: 'CANCELAR',
        confirmText: 'CONFIRMAR',
      );
    } else if (Platform.isIOS) {
      final initialTimerDuration = initialTime != null
          ? Duration(
              hours: initialTime.hour,
              minutes: initialTime.minute,
            )
          : Duration.zero;

      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoTimerPicker(
            backgroundColor:
                CupertinoColors.systemBackground.resolveFrom(context),
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: initialTimerDuration,
            onTimerDurationChanged: (duration) {
              final hours = duration.inMinutes ~/ 60;
              final minutes = duration.inMinutes % 60;

              selectedTime = TimeOfDay(
                hour: hours,
                minute: minutes,
              );
            },
          );
        },
      );
    }

    return selectedTime;
  }
}
