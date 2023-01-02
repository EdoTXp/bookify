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
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 30),
          Text(
            text,
            textAlign: TextAlign.center,
          ),
          if (suffixIcon != null)
            Row(
              children: [
                const SizedBox(width: 10),
                Icon(suffixIcon),
              ],
            ),
        ],
      ),
    );
  }
}
