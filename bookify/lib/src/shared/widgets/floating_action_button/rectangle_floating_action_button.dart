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
    // when the keyboard appears, FAB hides
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Visibility(
      visible: !keyboardIsOpen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          SizedBox(
            width: width ?? 60,
            height: height ?? 60,
            child: FloatingActionButton(
              onPressed: onPressed,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
