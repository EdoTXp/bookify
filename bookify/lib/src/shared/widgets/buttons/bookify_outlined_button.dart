import 'package:flutter/material.dart';

class BookifyOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData? suffixIcon;
  final String text;
  final bool isExpanded;

  const BookifyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = false,
  });

  const BookifyOutlinedButton.expanded({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: (isExpanded) ? MediaQuery.sizeOf(context).width : null,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(suffixIcon),
          label: Text(text),
        ),
      ),
    );
  }
}
