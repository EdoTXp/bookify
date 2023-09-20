import 'package:flutter/material.dart';

class RectangleFloatingActionButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final void Function() onPressed;
  final Widget child;

  const RectangleFloatingActionButton({
    super.key,
    this.width,
    this.height,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 80,
      height: height ?? 80,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
