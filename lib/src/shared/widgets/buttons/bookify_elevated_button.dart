import 'package:flutter/material.dart';

class BookifyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? suffixIcon;
  final bool isExpanded;

  const BookifyElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = false,
  });

  const BookifyElevatedButton.expanded({
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
        child: (suffixIcon != null)
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(suffixIcon),
                label: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                ),
              ),
      ),
    );
  }
}
