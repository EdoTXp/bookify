import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:flutter/material.dart';

class InfoItemStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  final String imageAssetPath;

  const InfoItemStateWidget({
    super.key,
    required this.message,
    required this.onPressed,
    required this.imageAssetPath,
  });

  /// Generate a InfoItemStateWidget for a error state
  const InfoItemStateWidget.withErrorState({
    super.key,
    required this.message,
    required this.onPressed,
    this.imageAssetPath = BookifyImages.bookErrorImage,
  });

  /// Generate a InfoItemStateWidget for a notFound state
  const InfoItemStateWidget.withNotFoundState({
    super.key,
    required this.message,
    required this.onPressed,
    this.imageAssetPath = BookifyImages.bookEmptyImage,
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
              'OPS!! $message',
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
