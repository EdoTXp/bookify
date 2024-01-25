import 'package:bookify/src/features/bookcase_detail/widgets/bookcase_description_widget/bookcase_description_widget.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/widgets/empty_item_widget/empty_item_widget.dart';
import 'package:flutter/material.dart';

class BookcaseDetailEmptyStateWidget extends StatelessWidget {
  final BookcaseModel bookcase;
  final VoidCallback onTap;

  const BookcaseDetailEmptyStateWidget({
    super.key,
    required this.bookcase,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          BookcaseDescriptionWidget(
            name: bookcase.name,
            description: bookcase.description,
            color: bookcase.color,
          ),
          Center(
            child: EmptyItemWidget(
              onTap: onTap,
              label: 'Adicionar novos Livros',
            ),
          ),
        ],
      ),
    );
  }
}
