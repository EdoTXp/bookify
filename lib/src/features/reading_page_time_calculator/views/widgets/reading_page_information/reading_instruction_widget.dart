import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReadingInstructionWidget extends StatelessWidget {
  const ReadingInstructionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        children: [
          Text(
            'reading-instruction-title'.i18n(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          Text(
            'reading-instruction-description'.i18n(),
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
