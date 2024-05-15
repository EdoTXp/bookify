import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';

class Ilustration4Page extends StatelessWidget {
  const Ilustration4Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Column(
      children: [
        Image.asset(
          height: mediaQuerySizeOf.height * .4,
          width: mediaQuerySizeOf.width,
          BookifyImages.ilustration_4,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Controle o tempo e os momentos de leitura',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 32,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Saiba quanto tempo você levará para ler aquele livro na sua estante calculando o seu tempo de leitura, e utilize o timer de leitura para definir por quanto tempo você pode ler.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
