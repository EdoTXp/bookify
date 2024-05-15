import 'package:flutter/material.dart';

class BookifyOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? suffixIcon;
  final Color? color;
  final bool isExpanded;

  const BookifyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.isExpanded = false,
    this.color,
  });

  const BookifyOutlinedButton.expanded({
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
            ? OutlinedButton.icon(
                onPressed: onPressed,
                style: color != null
                    ? ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                          color,
                        ),
                        side: WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: color!,
                          ),
                        ),
                        iconColor: WidgetStatePropertyAll(color!),
                      )
                    : null,
                icon: Icon(suffixIcon),
                label: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: color,
                  ),
                ),
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: color != null
                    ? ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                          color,
                        ),
                        side: WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: color!,
                          ),
                        ),
                        iconColor: WidgetStatePropertyAll(color!),
                      )
                    : null,
                child: Text(
                  text,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: color,
                  ),
                ),
              ),
      ),
    );
  }
}
