import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

extension BookStatusExtension on BookStatus {
  Color get color {
    return switch (this) {
      BookStatus.library => AppColor.bookifyBookLibraryColor,
      BookStatus.reading => AppColor.bookifyBookReadingColor,
      BookStatus.loaned => AppColor.bookifyBookLoanedColor,
    };
  }

  String get label {
    return switch (this) {
      BookStatus.library => 'book-on-the-bookcase-label'.i18n(),
      BookStatus.reading => 'book-on-reading-label'.i18n(),
      BookStatus.loaned => 'book-on-loan-label'.i18n(),
    };
  }
}
