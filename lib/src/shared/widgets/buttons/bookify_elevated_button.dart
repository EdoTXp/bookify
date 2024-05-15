import 'package:flutter/material.dart';

class BookifyElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? suffixIcon;
  final Color? color;
  final bool isExpanded;

  const BookifyElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = false,
    this.color,
  });

  const BookifyElevatedButton.expanded({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = true,
    this.color,
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
                style: color != null
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          color,
                        ),
                      )
                    : null,
                icon: Icon(suffixIcon),
                label: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: color != null
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          color,
                        ),
                      )
                    : null,
                child: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                ),
              ),
      ),
    );
  }
}
