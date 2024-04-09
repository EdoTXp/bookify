import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookifyRatingWidget extends StatelessWidget {
  final double averageRating;
  final double itemSize;
  final IconData fullyFilledIcon;
  final IconData halfFilledIcon;
  final IconData emptyFilledIcon;
  final Color? ratedColor;
  final Color? unratedColor;

  const BookifyRatingWidget({
    super.key,
    required this.averageRating,
    this.itemSize = 20.0,
    this.fullyFilledIcon = Icons.star_rounded,
    this.halfFilledIcon = Icons.star_half_rounded,
    this.emptyFilledIcon = Icons.star_border_rounded,
    this.ratedColor,
    this.unratedColor,
  });

  Icon _buildIconRating(int index, Color ratedColor) {
    IconData iconRating;

    if (index >= averageRating) {
      // If the star index is greater than or equal to the rating average, it shows a blank star.
      iconRating = emptyFilledIcon;
    } else if (index > averageRating - 1 && index < averageRating) {
      // If the star rating is greater than the rating average
      // minus one and less than the rating average, show a half star.
      iconRating = halfFilledIcon;
    } else {
      // Otherwise, it shows a solid star.
      iconRating = fullyFilledIcon;
    }

    return Icon(
      iconRating,
      color: ratedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ratedColor = this.ratedColor ?? colorScheme.secondary;
    final unratedColor = this.unratedColor ?? colorScheme.secondary;

    return RatingBarIndicator(
      rating: averageRating,
      unratedColor: unratedColor,
      itemSize: itemSize,
      itemBuilder: (_, index) => _buildIconRating(index, ratedColor),
    );
  }
}
