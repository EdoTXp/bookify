import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/bookify_rating/bookify_rating_widget.dart';
import 'package:flutter/material.dart';

class BookWithDetailWidget extends StatelessWidget {
  final String bookImageUrl;
  final String bookDescription;
  final double bookAverageRating;

  const BookWithDetailWidget({
    super.key,
    required this.bookImageUrl,
    required this.bookDescription,
    required this.bookAverageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            BookWidget(
              bookImageUrl: bookImageUrl,
              height: 220,
              width: 150,
            ),
            const SizedBox(
              height: 5,
            ),
            BookifyRatingWidget(
              averageRating: bookAverageRating,
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookDescription,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
