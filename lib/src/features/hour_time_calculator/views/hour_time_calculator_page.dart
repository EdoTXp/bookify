import 'package:bookify/src/features/programming_reading/views/programming_reading_page.dart';
import 'package:bookify/src/features/hour_time_calculator/views/widgets/reading_hour_introduction_text.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HourTimeCalculatorPage extends StatelessWidget {
  /// The Route Name = '/reading_time_calculator'
  static const routeName = '/reading_time_calculator';

  const HourTimeCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        ProgrammingReadingPage.routeName,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
