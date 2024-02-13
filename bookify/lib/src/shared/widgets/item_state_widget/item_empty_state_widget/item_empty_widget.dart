import 'package:flutter/material.dart';

class ItemEmptyStateWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const ItemEmptyStateWidget({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
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
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
