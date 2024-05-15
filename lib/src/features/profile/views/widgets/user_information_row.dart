import 'package:bookify/src/features/profile/views/widgets/item_status_column.dart';
import 'package:flutter/material.dart';

class UserInformationRow extends StatelessWidget {
  const UserInformationRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      textBaseline: TextBaseline.alphabetic,
      children: [
        ItemStatusColumn(
          quantity: 1,
          label: 'Estante',
        ),
        SizedBox(
          width: 5,
        ),
        ItemStatusColumn(
          quantity: 1,
          label: 'Livro',
        ),
        SizedBox(
          width: 5,
        ),
        ItemStatusColumn(
          quantity: 1,
          label: 'Empréstimo',
        ),
        SizedBox(
          width: 5,
        ),
        ItemStatusColumn(
          quantity: 1,
          label: 'Leitura',
        ),
      ],
    );
  }
}
