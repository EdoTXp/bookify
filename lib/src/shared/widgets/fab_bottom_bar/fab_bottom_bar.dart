/* 
Class inspired by an article from Andrea Bizzotto
Links:
  - https://codewithandrea.com/articles/bottom-bar-navigation-with-fab/
  - https://github.com/bizz84/bottom_bar_fab_flutter/blob/master/lib/fab_bottom_app_bar.dart
*/
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_tab_item.dart';
import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String label;

  FABBottomAppBarItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

const rectangleRoundedNotchedShape = AutomaticNotchedShape(
  RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
  ),
  RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
  ),
);

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem> items;
  final NotchedShape? notchedShape;
  final ValueChanged<int> onSelectedItem;
  final FabBottomBarController? controller;
  final double? width;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;

  const FABBottomAppBar({
    super.key,
    required this.items,
    required this.onSelectedItem,
    this.controller,
    this.notchedShape = rectangleRoundedNotchedShape,
    this.color,
    this.selectedColor,
    this.backgroundColor,
    this.width,
  });

  @override
  State<FABBottomAppBar> createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateIndexListener);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateIndexListener);
    super.dispose();
  }

  void _updateIndexListener() {
    int value = widget.controller!.value;
    int length = widget.items.length;

    assert(
      (value >= 0) && (value < length),
      'Selected item: $value. The selected item must be between 0 and ${length - 1}.',
    );
    _updateIndex(value);
  }

  void _updateIndex(int index) {
    setState(() {
      widget.onSelectedItem(index);
      _selectedItemIndex = index;
    });
  }

  List<Widget> _getRowItems() {
    List<Widget> items = List.generate(
      widget.items.length,
      ((index) {
        return FabTabItem(
          item: widget.items[index],
          onPressed: () => _updateIndex(index),
          isSelected: _selectedItemIndex == index,
        );
      }),
    );

    // add SizedBox when icons are close to FAB
    items.insert(
      items.length >> 1,
      const SizedBox(
        height: 60,
        width: 60,
      ),
    );
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Avoid onTaps below the bottomBar.
      decoration: const BoxDecoration(),
      child: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        color: widget.backgroundColor,
        shape: widget.notchedShape,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _getRowItems(),
        ),
      ),
    );
  }
}
