import 'package:flutter/material.dart';

class ShowDialogService {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback cancelButtonFunction,
    required VoidCallback confirmButtonFunction,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: cancelButtonFunction,
              child: const Text(
                'NÃO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: confirmButtonFunction,
              child: const Text(
                'CONFIRMAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
