import 'package:flutter/material.dart';

class ItemStatusColumn extends StatelessWidget {
  final int quantity;
  final String label;

  const ItemStatusColumn({
    super.key,
    required this.quantity,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          quantity.toString(),
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
