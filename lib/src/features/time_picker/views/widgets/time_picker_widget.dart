import 'package:bookify/src/core/helpers/color_brightness/color_brightness_extension.dart';
import 'package:bookify/src/core/services/app_services/time_picker_dialog_service.dart/time_picker_dialog_service.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final void Function(TimeOfDay time) onTimeSelected;
  final int? hour;
  final int? minute;

  const TimePickerWidget({
    super.key,
    required this.onTimeSelected,
    this.hour,
    this.minute,
  });

  Future<void> _onTimeSelected(
    BuildContext context,
    TimeOfDay initialTime,
  ) async {
    final time = await TimePickerDialogService.showTimePickerDialog(
        context, initialTime);

    if (time != null) {
      onTimeSelected(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeHour = hour ?? 0;
    final timeMinute = minute ?? 0;

    return Material(
      child: InkWell(
        onTap: () async => await _onTimeSelected(
          context,
          TimeOfDay(
            hour: timeHour,
            minute: timeMinute,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.lighten(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECIONE A HORA',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.lighten(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeHour.toString().padLeft(2, '0'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    ':',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeMinute.toString().padLeft(2, '0'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
