import 'package:flutter/material.dart';

class FloatingActionButtonAlignedCenterDockerLocation
    extends FloatingActionButtonLocation {


  const FloatingActionButtonAlignedCenterDockerLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    scaffoldGeometry.contentBottom;

    return Offset(
      scaffoldGeometry.scaffoldSize.width * .42,
      scaffoldGeometry.contentBottom,
    );
  }
}

/// Align the floating Action Button on center bottom and align with the items of bottombar. 
const floatingItemAlignedCenterDockerPosition =
    FloatingActionButtonAlignedCenterDockerLocation();

class RectangleFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
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
      child: FloatingActionButton(
        tooltip: tooltip,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
