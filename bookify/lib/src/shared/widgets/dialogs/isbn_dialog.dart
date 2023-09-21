import 'package:flutter/material.dart';

class IsbnDialog extends StatelessWidget {
  const IsbnDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(32),
        child: const Text(
          'O ISBN tem que ter apenas 10 ou 13 números, podendo conter o ( - ).',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
