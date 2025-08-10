import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReadingHourIntroductionText extends StatelessWidget {
  const ReadingHourIntroductionText({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'reading-time-title'.i18n(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'reading-time-description'.i18n(),
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
