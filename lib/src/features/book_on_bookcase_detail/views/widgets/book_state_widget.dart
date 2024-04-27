import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter/material.dart';

class BookStateWidget extends StatelessWidget {
  final BookStatus bookStatus;

  const BookStateWidget({
    super.key,
    required this.bookStatus,
  });

  Color _getColor() {
    return switch (bookStatus) {
      BookStatus.library => Colors.green,
      BookStatus.reading => Colors.amber,
      BookStatus.loaned => Colors.blue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          22,
        ),
      ),
      child: Text(
        bookStatus.toString(),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        textScaler: TextScaler.noScaling,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
