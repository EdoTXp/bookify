/* 
Class inspired by an article from Andrea Bizzotto
Links:
  - https://codewithandrea.com/articles/bottom-bar-navigation-with-fab/
  - https://github.com/bizz84/bottom_bar_fab_flutter/blob/master/lib/fab_bottom_app_bar.dart
*/
import 'package:bookify/src/features/root/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
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
    ));

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

  void _updateIndex(int index) {
    setState(() {
      widget.onSelectedItem(index);
      _selectedItemIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        _updateIndex(widget.controller!.value);
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
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
    final isSelected = _selectedItemIndex == index;

    final color = isSelected
        ? widget.selectedColor ?? Theme.of(context).primaryColor
        : widget.color ?? Theme.of(context).unselectedWidgetColor;

    final icon = isSelected ? item.selectedIcon : item.unselectedIcon;

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
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(90),
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color),
                Text(
                  item.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: color,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
