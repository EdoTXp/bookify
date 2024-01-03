import 'package:flutter/material.dart';

class BookifyOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData? suffixIcon;
  final String text;

  const BookifyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(suffixIcon),
        label: Text(text),
      ),
    );
  }
}
