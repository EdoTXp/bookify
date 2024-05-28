import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? lightColor;
  final Color? darkColor;

  const SettingsContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.lightColor,
    this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: Theme.of(context).brightness == Brightness.light
            ? lightColor ?? Colors.grey[100]
            : darkColor ?? Colors.black87,
      ),
      child: child,
    );
  }
}
