import 'package:flutter/material.dart';

class ReadingInformationWidget extends StatelessWidget {
  const ReadingInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Vamos calcular a sua velocidade de leitura?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Leia um pequeno trecho extraido de um livro gerado por uma IA, enquanto acompanhamos o seu tempo com um cronômetro. Após o cálculo, você terá informado em qualquer livro no aplicativo, o tempo médio para finalizar a leitura dessa determinada obra, baseado no tempo que você levou para ler o texto.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
