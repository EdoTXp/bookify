import 'package:bookify/src/features/profile/views/widgets/item_status_column.dart';
import 'package:flutter/material.dart';

class UserInformationRow extends StatelessWidget {
  const UserInformationRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'Sem nome',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const ItemStatusColumn(
          quantity: 1,
          label: 'Estante',
        ),
        const SizedBox(
          width: 5,
        ),
        const ItemStatusColumn(
          quantity: 1,
          label: 'Livro',
        ),
        const SizedBox(
          width: 5,
        ),
        const ItemStatusColumn(
          quantity: 1,
          label: 'Empréstimo',
        ),
        const SizedBox(
          width: 5,
        ),
        const ItemStatusColumn(
          quantity: 1,
          label: 'Leitura',
        ),
      ],
    );
  }
}
