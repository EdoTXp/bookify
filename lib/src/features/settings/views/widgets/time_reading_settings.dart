import 'package:bookify/src/features/reading_page_time_calculator/views/reading_page_time_calculator_page.dart';
import 'package:bookify/src/features/settings/views/widgets/settings_container.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class TimeReadingSettings extends StatelessWidget {
  const TimeReadingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'reading-time-label'.i18n(),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'time-to-read-description'.i18n(),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              child: Text(
                'do-recount-button'.i18n(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.tertiary,
                ),
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                ReadingPageTimeCalculatorPage.routeName,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
