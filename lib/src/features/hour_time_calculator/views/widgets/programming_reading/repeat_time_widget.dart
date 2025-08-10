import 'package:bookify/src/core/helpers/color_brightness/color_brightness_extension.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class RepeatTimeWidget extends StatelessWidget {
  final void Function(int selectedTime) onSelectedRepeatTime;
  final int? initialRepeatTimeSelected;

  const RepeatTimeWidget({
    super.key,
    required this.onSelectedRepeatTime,
    this.initialRepeatTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: mediaQuerySizeOf.width,
      decoration: BoxDecoration(
        color: colorScheme.primary.darken(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'repeat-time-title'.i18n(),
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownMenu<int>(
            initialSelection: initialRepeatTimeSelected,
            dropdownMenuEntries: [
              DropdownMenuEntry(
                label: 'daily-dropdown-menu-entry'.i18n(),
                value: 1,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16)),
                ),
              ),
              DropdownMenuEntry(
                label: 'weekly-dropdown-menu-entry'.i18n(),
                value: 2,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 16)),
                ),
              ),
            ],
            onSelected: (value) {
              if (value != null) {
                onSelectedRepeatTime(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
