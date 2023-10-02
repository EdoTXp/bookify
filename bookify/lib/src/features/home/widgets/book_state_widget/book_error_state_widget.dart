import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/buttons.dart';

// Images source:
// Book Icon: https://www.kindpng.com/imgv/JJhxRx_open-book-icon-book-emoji-hd-png-download/
// Lupe: https://www.kindpng.com/imgv/ToRobT_magnifying-glass-svg-clip-arts-hd-png-download/
// Cross Error: https://www.kindpng.com/imgv/iRJmhih_cross-hd-png-download/

class BookErrorSateWidget extends StatelessWidget {
  final String imageAssetPath;
  final String stateMessage;
  final void Function() onPressed;

  const BookErrorSateWidget({
    required this.stateMessage,
    required this.onPressed,
    this.imageAssetPath = 'assets/icons/error_book.png',
    super.key,
  });

  /// Generate a BookErrorSateWidget with [imageAssetPath] using this ['assets/icons/empty_book.png']
  /// and a [stateMessage] using default message
  const BookErrorSateWidget.bookEmptyState({
    required this.onPressed,
    this.imageAssetPath = 'assets/icons/empty_book.png',
    this.stateMessage = 'Não foi encontrado nenhum livro com esses termos.',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageAssetPath),
            const SizedBox(
              height: 20,
            ),
            Text(
              'OPS!! $stateMessage',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 4,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 20,
            ),
            BookifyElevatedButton(
              onPressed: onPressed,
              suffixIcon: Icons.replay_outlined,
              text: 'Tentar novamente',
            ),
          ],
        ),
      ),
    );
  }
}
