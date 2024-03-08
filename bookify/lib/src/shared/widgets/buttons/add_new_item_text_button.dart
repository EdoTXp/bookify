import 'package:flutter/material.dart';

class AddNewItemTextButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onPressed;

  const AddNewItemTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconData = Icons.add_circle_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      icon: Icon(
        iconData,
        color: colorScheme.secondary,
      ),
      label: Text(
        label,
      ),
      onPressed: onPressed,
    );
  }
}
