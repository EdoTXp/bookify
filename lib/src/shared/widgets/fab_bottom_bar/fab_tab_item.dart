import 'dart:math';

import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

/// Represents a single tab item in the FAB bottom bar.
/// This widget displays an icon and label for each tab,
/// and handles the visual feedback when selected.
class FabTabItem extends StatelessWidget {
  /// The data model for the tab item, containing the icon and label.
  final FABBottomAppBarItem item;

  /// Callback function executed when the tab item is tapped.
  final VoidCallback onPressed;

  /// The color to use for the selected state of the tab item.
  final Color? selectedColor;

  /// The color to use for the unselected state of the tab item.
  final Color? color;

  /// Indicates whether the tab item is currently selected.
  final bool isSelected;

  /// Constructs a new instance of FabTabItem.
  ///
  /// [key] The unique key for this widget.
  ///
  /// [item] The data model for the tab item.
  ///
  /// [onPressed] The callback function executed when the tab item is tapped.
  ///
  /// [isSelected] Indicates whether the tab item is currently selected.
  ///
  /// [selectedColor] The color to use for the selected state of the tab item.
  ///
  /// [color] The color to use for the unselected state of the tab item.

  const FabTabItem({
    super.key,
    required this.item,
    required this.onPressed,
    required this.isSelected,
    this.selectedColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieves the current theme's color scheme.
    final colorScheme = Theme.of(context).colorScheme;

    // Creates a tooltip for accessibility purposes.
    return Tooltip(
      message: 'page-tooltip'.i18n([item.label]),
      child: Material(
        borderRadius: BorderRadius.circular(90),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(90),
          splashColor: Colors.transparent,
          onTap: onPressed,
          child: isSelected
              // If the item is selected, animate the border and content.
              ? TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCirc,
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: AnimatedCircleBorderPainter(
                        currentAnimationPaintState: value,
                        borderColor: selectedColor ?? colorScheme.secondary,
                      ),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.selectedIcon,
                              color: selectedColor ?? colorScheme.secondary,
                            ),
                            Text(
                              item.label,
                              textScaler: TextScaler.noScaling,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: selectedColor ?? colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : SizedBox(
                  width: 60,
                  height: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.unselectedIcon,
                        color: color ?? colorScheme.primary,
                      ),
                      Text(
                        item.label,
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: color ?? colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

/// Custom painter for drawing the animated circle border
/// around the selected tab item.
class AnimatedCircleBorderPainter extends CustomPainter {
  final double currentAnimationPaintState;
  final Color borderColor;
  final double borderSize;

  const AnimatedCircleBorderPainter({
    required this.currentAnimationPaintState,
    required this.borderColor,
    this.borderSize = 1.0,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = const Offset(0, 0) & Size(size.width, size.height);

    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderSize
      ..style = PaintingStyle.stroke;

    const centerBottomCircleStartAngle = pi / 2;
    final halfCircle = currentAnimationPaintState * pi;
    final circle = halfCircle * 2;

    canvas.drawArc(
      rect,
      centerBottomCircleStartAngle,
      circle,
      false,
      paint,
    );
  }
}
