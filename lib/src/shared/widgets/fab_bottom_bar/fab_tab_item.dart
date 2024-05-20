import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:flutter/material.dart';

class FabTabItem extends StatelessWidget {
  final FABBottomAppBarItem item;
  final VoidCallback onPressed;
  final Color? selectedColor;
  final Color? color;
  final bool isSelected;

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
    final colorScheme = Theme.of(context).colorScheme;
    final colorItem = isSelected
        ? selectedColor ?? colorScheme.secondary
        : color ?? colorScheme.primary;

    final iconItem = isSelected ? item.selectedIcon : item.unselectedIcon;

    return Tooltip(
      message: 'Página: ${item.label}',
      child: Material(
        borderRadius: BorderRadius.circular(90),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(90),
          splashColor: Colors.transparent,
          onTap: onPressed,
          child: Container(
            width: 60,
            height: 60,
            decoration: isSelected
                // Circle created only when item is selected.
                ? BoxDecoration(
                    border: Border.all(
                      color: colorItem,
                    ),
                    borderRadius: BorderRadius.circular(90),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconItem,
                  color: colorItem,
                ),
                Text(
                  item.label,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: colorItem,
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
