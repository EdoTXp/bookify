import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookRating extends StatelessWidget {
  final double averageRating;
  final int ratingsCount;

  const BookRating({
    super.key,
    required this.averageRating,
    required this.ratingsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$averageRating',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        RatingBarIndicator(
          rating: averageRating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Theme.of(context).primaryColor,
          ),
          itemSize: 20,
        ),
        Text(
          'Total: $ratingsCount',
          style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
        )
      ],
    );
  }
}
