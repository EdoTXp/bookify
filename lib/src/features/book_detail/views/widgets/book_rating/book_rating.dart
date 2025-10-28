import 'package:bookify/src/core/helpers/locale_decimal_format/locale_decimal_format_extension.dart';
import 'package:bookify/src/shared/widgets/bookify_rating/bookify_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          averageRating.toLocaleDecimalFormat(),
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.secondary,
          ),
        ),
        BookifyRatingWidget(
          averageRating: averageRating,
        ),
        Text(
          'total-ratings'.i18n([ratingsCount.toString()]),
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
