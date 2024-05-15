import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';

class Ilustration1Page extends StatelessWidget {
  const Ilustration1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return Column(
      children: [
        Image.asset(
          height: mediaQuerySizeOf.height * .4,
          width: mediaQuerySizeOf.width,
          BookifyImages.ilustration_1,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Biblioteca com milhares de livros',
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
          'Crie estantes virtuais no app, catalogue e organize seus livros com uma biblioteca com milhares de obras.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
