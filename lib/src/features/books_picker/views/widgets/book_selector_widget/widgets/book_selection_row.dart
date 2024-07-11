import 'package:flutter/material.dart';

class BookSelectedRow extends StatelessWidget {
  final VoidCallback onClearPressed;
  final VoidCallback onConfirmPressed;

  const BookSelectedRow({
    super.key,
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
            'Livro selecionado',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClearPressed,
            tooltip: 'Desselecionar Livro',
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            key: const Key('Confirm IconButton'),
            onPressed: onConfirmPressed,
            tooltip: 'Enviar Livro',
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}
