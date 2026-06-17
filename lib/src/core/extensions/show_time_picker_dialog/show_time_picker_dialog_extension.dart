import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

extension ShowTimePickerDialogExtension on BuildContext {
  Future<TimeOfDay?> showTimePickerDialog([
    TimeOfDay? initialTime,
  ]) async {
    TimeOfDay? selectedTime;

    if (Platform.isAndroid) {
      selectedTime = await showTimePicker(
        context: this,
        initialTime: initialTime ?? const TimeOfDay(hour: 0, minute: 0),
        helpText: 'select-hours-and-minutes-title'.i18n(),
        hourLabelText: 'hours-label'.i18n(),
        minuteLabelText: 'minutes-label'.i18n(),
        errorInvalidText: 'error-get-time'.i18n(),
        cancelText: 'cancel-button'.i18n(),
        confirmText: 'confirm-button'.i18n(),
      );
    } else if (Platform.isIOS) {
      final initialTimerDuration = initialTime != null
          ? Duration(
              hours: initialTime.hour,
              minutes: initialTime.minute,
            )
          : Duration.zero;

      await showCupertinoModalPopup(
        context: this,
        builder: (context) {
          return CupertinoTimerPicker(
            backgroundColor: CupertinoColors.systemBackground.resolveFrom(
              context,
            ),
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
