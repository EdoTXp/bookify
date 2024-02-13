import 'package:flutter/material.dart';

class SelectedBookcaseRow extends StatefulWidget {
  final int bookcaseQuantity;
  final VoidCallback onPressedDeleteButton;
  final Function(bool isSelected) onSelectedAll;

  const SelectedBookcaseRow({
    super.key,
    required this.bookcaseQuantity,
    required this.onPressedDeleteButton,
    required this.onSelectedAll,
  });

  @override
  State<SelectedBookcaseRow> createState() => _SelectedBookcaseRowState();
}

class _SelectedBookcaseRowState extends State<SelectedBookcaseRow> {
  bool _isSelectedAll = false;

  (
    String selectedAllText,
    IconData selectedAllIcon,
  ) _getAllIconButtonProperties() {
    return switch (_isSelectedAll) {
      true => (
          'Deselecionar Tudo',
          Icons.deselect_rounded,
        ),
      false => (
          'Selecionar Tudo',
          Icons.select_all_rounded,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookcaseText =
        (widget.bookcaseQuantity == 1) ? 'Estante' : 'Estantes';

    final (selectedAllText, selectedAllIcon) = _getAllIconButtonProperties();

    return Container(
      color: colorScheme.primary.withOpacity(.1),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            '$bookcaseText: ${widget.bookcaseQuantity}',
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
            tooltip: 'Deletar',
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
    );
  }
}
