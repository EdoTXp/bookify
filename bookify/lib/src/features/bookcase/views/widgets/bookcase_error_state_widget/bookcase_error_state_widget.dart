import 'package:bookify/src/shared/constants/images/bookify_images.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:flutter/material.dart';

class BookcaseErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;

  const BookcaseErrorStateWidget({
    super.key,
    required this.message,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            BookifyImages.bookErrorImage,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          BookifyElevatedButton.expanded(
            onPressed: onPressed,
            text: 'Tentar novamente',
            suffixIcon: Icons.repeat_rounded,
          ),
        ],
      ),
    );
  }
}
