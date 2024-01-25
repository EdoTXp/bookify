import 'package:flutter/material.dart';

class BookcaseDescriptionWidget extends StatelessWidget {
  final String name;
  final String description;
  final Color color;
  final int booksQuantity;

  const BookcaseDescriptionWidget({
    super.key,
    required this.name,
    required this.description,
    required this.color,
    this.booksQuantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookTextQuantity = (booksQuantity >= 1) ? 'livros' : 'livro';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$booksQuantity $bookTextQuantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          description,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Divider(color: colorScheme.primary.withOpacity(.5)),
      ],
    );
  }
}
