import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SelectedItemRow extends StatefulWidget {
  final int itemQuantity;
  final VoidCallback onPressedDeleteButton;
  final void Function(bool isSelectedAll) onSelectedAll;
  final String itemLabelSingular;
  final String itemLabelPlural;

  const SelectedItemRow({
    super.key,
    required this.itemQuantity,
    required this.onPressedDeleteButton,
    required this.onSelectedAll,
    required this.itemLabelSingular,
    required this.itemLabelPlural,
  });

  @override
  State<SelectedItemRow> createState() => _SelectedItemRowState();
}

class _SelectedItemRowState extends State<SelectedItemRow> {
  bool _isSelectedAll = false;

  (
    String selectedAllText,
    IconData selectedAllIcon,
  ) _getAllIconButtonProperties() {
    return switch (_isSelectedAll) {
      true => (
          'deselect-all-button'.i18n(),
          Icons.deselect_rounded,
        ),
      false => (
          'select-all-button'.i18n(),
          Icons.select_all_rounded,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemText = (widget.itemQuantity == 1)
        ? widget.itemLabelSingular
        : widget.itemLabelPlural;

    final (selectedAllText, selectedAllIcon) = _getAllIconButtonProperties();

    return Container(
      color: colorScheme.primary.withValues(
        alpha: .1,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            '$itemText: ${widget.itemQuantity}',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _isSelectedAll = !_isSelectedAll;
                widget.onSelectedAll(_isSelectedAll);
              });
            },
            tooltip: selectedAllText,
            icon: Icon(selectedAllIcon),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: widget.onPressedDeleteButton,
            tooltip:
                'delete-item-button-tooltip'.i18n([itemText.toLowerCase()]),
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
    );
  }
}
