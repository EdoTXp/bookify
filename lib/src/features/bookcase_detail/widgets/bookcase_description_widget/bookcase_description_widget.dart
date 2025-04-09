import 'package:bookify/src/core/helpers/color_brightness/color_brightness_extension.dart';
import 'package:flutter/material.dart';

class BookcaseDescriptionWidget extends StatelessWidget {
  final String name;
  final String? description;
  final Color color;
  final int booksQuantity;

  const BookcaseDescriptionWidget({
    super.key,
    required this.name,
    this.description,
    required this.color,
    this.booksQuantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookTextQuantity = (booksQuantity == 1) ? 'livro' : 'livros';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
        const SizedBox(height: 10),
        Text(
          description ?? '...',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 14,
          ),
        ),
        Divider(
          color: (Theme.of(context).brightness == Brightness.dark)
              ? color.lighten(.2)
              : color.darken(.2),
        ),
      ],
    );
  }
}
