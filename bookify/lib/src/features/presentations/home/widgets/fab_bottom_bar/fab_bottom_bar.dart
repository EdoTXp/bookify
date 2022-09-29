/* 
Class inspired by an article from Andrea Bizzotto
Links:
  - https://codewithandrea.com/articles/bottom-bar-navigation-with-fab/
  - https://github.com/bizz84/bottom_bar_fab_flutter/blob/master/lib/fab_bottom_app_bar.dart
*/
import 'package:flutter/material.dart';

class FABBottomAppBarItem {
  final IconData iconData;
  final IconData selectedIcon;
  final String text;

  FABBottomAppBarItem({
    required this.selectedIcon,
    required this.iconData,
    required this.text,
  });
}

const rectangeRoundedNotchedShape = AutomaticNotchedShape(
    RoundedRectangleBorder(),
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ));

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem> items;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final double? width;
  final Color? backgroundColor;
  final Color color;
  final Color selectedColor;

  const FABBottomAppBar({
    super.key,
    required this.items,
    required this.notchedShape,
    required this.onTabSelected,
    required this.color,
    required this.selectedColor,
    this.backgroundColor,
    this.width,
  });

  @override
  State<FABBottomAppBar> createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
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
      color: widget.backgroundColor,
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? widget.selectedColor : widget.color;
    final icon = isSelected ? item.selectedIcon : item.iconData;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60,
        height: 60,
        decoration: isSelected
            ? BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(90))
            : null,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                Text(
                  item.text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12, color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
