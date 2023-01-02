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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
