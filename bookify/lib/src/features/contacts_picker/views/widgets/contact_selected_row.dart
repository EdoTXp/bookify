import 'package:flutter/material.dart';

class ContactSelectedRow extends StatelessWidget {
  final VoidCallback onClearPressed;
  final VoidCallback onConfirmPressed;

  const ContactSelectedRow({
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
            'Contato selecionado',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClearPressed,
            tooltip: 'Deselecionar Contato',
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: onConfirmPressed,
            tooltip: 'Enviar Contato',
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}
