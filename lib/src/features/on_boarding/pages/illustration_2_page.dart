import 'package:flutter/material.dart';

import '../../../shared/constants/images/bookify_images.dart';

class Illustration2Page extends StatelessWidget {
  const Illustration2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuerySizeOf = MediaQuery.sizeOf(context);

    return SizedBox(
      height: mediaQuerySizeOf.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return Image.asset(
                height: mediaQuerySizeOf.height * .4,
                width: constraints.maxWidth > 400
                    ? mediaQuerySizeOf.width * .5
                    : mediaQuerySizeOf.width,
                BookifyImages.ilustration_2,
                fit: BoxFit.fill,
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Escaneie seus livros com facilidade',
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
              'Use a câmera para escanear o código de barras, QR Code ou o número do ISBN dos seus livros e os adicione na sua estante.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
