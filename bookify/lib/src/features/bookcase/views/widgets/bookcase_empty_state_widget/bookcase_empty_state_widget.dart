import 'package:flutter/material.dart';

class BookcaseEmptyStateWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BookcaseEmptyStateWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SizedBox(
        child: Material(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 96,
                    color: colorScheme.secondary,
                  ),
                  const Text('Criar uma nova estante'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
