/* 
Class inspired by an article from Andrea Bizzotto
Links:
  - https://codewithandrea.com/articles/bottom-bar-navigation-with-fab/
  - https://github.com/bizz84/bottom_bar_fab_flutter/blob/master/lib/fab_bottom_app_bar.dart
*/
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String text;

  FABBottomAppBarItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.text,
  });
}

const rectangeRoundedNotchedShape = AutomaticNotchedShape(
  RoundedRectangleBorder(),
  RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem> items;
  final NotchedShape notchedShape;
  final ValueChanged<int> onSelectedItem;
  final FabBottomBarController? controller;
  final double? width;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;

  const FABBottomAppBar({
    super.key,
    required this.items,
    required this.notchedShape,
    required this.onSelectedItem,
    this.controller,
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

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        int value = widget.controller!.value;
        int length = widget.items.length;

        if ((value >= 0) && (value < length)) {
          _updateIndex(value);
        } else {
          throw ArgumentError(
              'Selected item: $value. The selected item must be between 0 and ${length - 1}.');
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  void _updateIndex(int index) {
    setState(() {
      widget.onSelectedItem(index);
      _selectedItemIndex = index;
    });
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final isSelectedItem = _selectedItemIndex == index;

    final colorItem = isSelectedItem
        ? widget.selectedColor ?? Theme.of(context).primaryColor
        : widget.color ?? Theme.of(context).unselectedWidgetColor;

    final iconItem = isSelectedItem ? item.selectedIcon : item.unselectedIcon;

    return Container(
      width: 60,
      height: 60,
      decoration: isSelectedItem
          // Circle created only when item is selected.
          ? BoxDecoration(
              border: Border.all(color: colorItem),
              borderRadius: BorderRadius.circular(90),
            )
          : null,
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(90),
        onTap: () => onPressed(index),
        // Icon and label of the item in a column.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconItem,
              color: colorItem,
            ),
            Text(
              item.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: colorItem,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, ((index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    }));

    // add SizedBox when icons are close to FAB
    items.insert(
        items.length >> 1,
        const SizedBox(
          width: 55,
        ));

    return BottomAppBar(
      padding: const EdgeInsets.all(8.0),
      color: widget.backgroundColor,
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}
