import 'package:bookify/src/core/helpers/book_status/book_status_extension.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:flutter/material.dart';

class BookStateWidget extends StatelessWidget {
  final BookStatus bookStatus;

  const BookStateWidget({
    super.key,
    required this.bookStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bookStatus.color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        bookStatus.label,
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
