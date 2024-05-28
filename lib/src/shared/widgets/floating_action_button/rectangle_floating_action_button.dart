import 'package:flutter/material.dart';

class _FloatingActionButtonAlignedCenterDockerLocation
    extends FloatingActionButtonLocation {
  const _FloatingActionButtonAlignedCenterDockerLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double centerWidth = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;

    final double centerHeight = scaffoldGeometry.contentBottom;

    return Offset(
      centerWidth,
      centerHeight,
    );
  }
}

/// Align the floating Action Button on center bottom and align with the items of bottombar.
const floatingItemAlignedCenterDockerPosition =
    _FloatingActionButtonAlignedCenterDockerLocation();

class RectangleFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const RectangleFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
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
