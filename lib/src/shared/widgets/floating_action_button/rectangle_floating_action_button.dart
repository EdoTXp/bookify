import 'package:flutter/material.dart';

class RectangleFloatingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const RectangleFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
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
              tooltip: tooltip,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              onPressed: onPressed,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
