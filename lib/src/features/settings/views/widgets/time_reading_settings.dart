import 'package:bookify/src/core/helpers/color_brightness/color_brightness_extension.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/reading_page_time_calculator_page.dart';
import 'package:flutter/material.dart';

class TimeReadingSettings extends StatelessWidget {
  const TimeReadingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100]
            : Colors.black87,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tempo de leitura',
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Faça a leitura de uma página enquanto fazemos o cálculo para descobrir quanto tempo você leva para ler qualquer livro.',
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 14,
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
                'Fazer uma nova contagem',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary.darken(),
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
