import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BookStateWidget extends StatelessWidget {
  final BookStatus bookStatus;

  const BookStateWidget({
    super.key,
    required this.bookStatus,
  });

  Color _getColor() {
    return switch (bookStatus) {
      BookStatus.library => AppColor.bookifyBookLibraryColor,
      BookStatus.reading => AppColor.bookifyBookReadingColor,
      BookStatus.loaned => AppColor.bookifyBookLoanedColor,
    };
  }

  String _getBookStatusToString() {
    return switch (bookStatus) {
      BookStatus.library => 'book-on-the-bookcase-label'.i18n(),
      BookStatus.reading => 'book-on-reading-label'.i18n(),
      BookStatus.loaned => 'book-on-loan-label'.i18n(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        _getBookStatusToString(),
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
