import 'package:bookify/src/features/hour_time_calculator/views/widgets/reading_hour_information/reading_hour_introduction_text.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:localization/localization.dart';

class ReadingHourInformation extends StatelessWidget {
  final VoidCallback onPressedProgramming;

  const ReadingHourInformation({
    super.key,
    required this.onPressedProgramming,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            const ReadingHourIntroductionText(),
            const Spacer(),
            Row(
              children: [
                Flexible(
                  key: const Key('Late Calculate Hour Button'),
                  child: BookifyOutlinedButton.expanded(
                    text: 'choose-later-button'.i18n(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: BookifyElevatedButton.expanded(
                    text: 'schedule-now-button'.i18n(),
                    onPressed: onPressedProgramming,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
