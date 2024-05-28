import 'package:bookify/src/features/hour_time_calculator/views/hour_time_calculator_page.dart';
import 'package:bookify/src/features/settings/views/widgets/settings_container.dart';
import 'package:flutter/material.dart';

class HourReadingSettings extends StatelessWidget {
  const HourReadingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hora da leitura',
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
          TextButton(
            child: Text(
              'Ver meus horários',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.tertiary,
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              HourTimeCalculatorPage.routeName,
            ),
          ),
        ],
      ),
    );
  }
}
