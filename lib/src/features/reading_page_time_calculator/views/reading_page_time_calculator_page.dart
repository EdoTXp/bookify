import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_instruction_widget.dart';
import 'package:bookify/src/features/reading_page_timer/views/reading_page_timer_page.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReadingPageTimeCalculatorPage extends StatelessWidget {
  /// The Route Name = '/reading_page_time_calculator'
  static const routeName = '/reading_page_time_calculator';

  const ReadingPageTimeCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              const ReadingInstructionWidget(),
              const Spacer(),
              Row(
                children: [
                  Flexible(
                    key: const Key('Late Calculate Reading Button'),
                    child: BookifyOutlinedButton.expanded(
                      text: 'calculate-later-button'.i18n(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: BookifyElevatedButton.expanded(
                      text: 'calculate-time-button'.i18n(),
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        ReadingPageTimerPage.routeName,
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
