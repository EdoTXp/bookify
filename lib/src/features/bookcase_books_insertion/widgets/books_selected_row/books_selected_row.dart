import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BooksSelectedRow extends StatelessWidget {
  final int booksQuantity;
  final VoidCallback onClearPressed;
  final VoidCallback onConfirmPressed;

  const BooksSelectedRow({
    super.key,
    required this.booksQuantity,
    required this.onClearPressed,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        children: [
          Text(
            'selected-books-quantity-label'.i18n([booksQuantity.toString()]),
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClearPressed,
            tooltip: 'clear-selection-button'.i18n(),
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            key: const Key('ConfirmBookIconButton'),
            onPressed: onConfirmPressed,
            tooltip: 'confirm-selection-button'.i18n(),
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}
