import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onPressed;

  const TextIconButton({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textThemeColor = Theme.of(context).textTheme.bodyMedium?.color;

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: colorScheme.secondary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textThemeColor,
        ),
      ),
    );
  }
}
