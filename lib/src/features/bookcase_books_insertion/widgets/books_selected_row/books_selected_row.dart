import 'package:flutter/material.dart';

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
            'Livros selecionados: $booksQuantity',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClearPressed,
            tooltip: 'Apagar seleção',
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            key: const Key('Confirm book IconButton'),
            onPressed: onConfirmPressed,
            tooltip: 'Confirmar a seleção',
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}
