import 'package:bookify/src/features/hour_time_calculator/views/widgets/reading_hour_information/reading_hour_text.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/widgets/buttons/buttons.dart';

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
            const ReadingHourText(),
            const Spacer(),
            Row(
              children: [
                Flexible(
                  child: BookifyOutlinedButton.expanded(
                    text: 'Escolher depois',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: BookifyElevatedButton.expanded(
                    text: 'Programar agora',
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
