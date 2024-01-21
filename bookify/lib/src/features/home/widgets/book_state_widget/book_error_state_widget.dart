import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/buttons/buttons.dart';

class BookErrorSateWidget extends StatelessWidget {
  final String imageAssetPath;
  final String stateMessage;
  final void Function() onPressed;

  const BookErrorSateWidget({
    required this.stateMessage,
    required this.onPressed,
    this.imageAssetPath = BookifyImages.bookErrorImage,
    super.key,
  });

  /// Generate a BookErrorSateWidget for a empty state with a [stateMessage] using default message
  const BookErrorSateWidget.bookEmptyState({
    required this.onPressed,
    this.imageAssetPath = BookifyImages.bookEmptyImage,
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
            BookifyElevatedButton.expanded(
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
