import 'package:flutter/material.dart';

class ReadingHourText extends StatelessWidget {
  const ReadingHourText({super.key});

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
            'Hora da leitura!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            '''A programação para um momento de leitura é o primeiro passo para criar o hábito.
            \nDefina quais dias e o melhor horário para as suas leituras, e a gente te lembrará aqui nas notificações!''',
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
