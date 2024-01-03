import 'package:flutter/material.dart';

class BookifyElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final IconData? suffixIcon;

  const BookifyElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(suffixIcon),
        label: Text(text),
      ),
    );
  }
}
