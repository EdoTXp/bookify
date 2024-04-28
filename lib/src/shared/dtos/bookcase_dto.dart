

import 'package:bookify/src/shared/models/bookcase_model.dart';

class BookcaseDto {
  final BookcaseModel bookcase;
  final String? bookImagePreview;
  
  const BookcaseDto({
    required this.bookcase,
    this.bookImagePreview,
  });

  BookcaseDto copyWith({
    BookcaseModel? bookcase,
    String? bookImagePreview,
  }) {
    return BookcaseDto(
      bookcase: bookcase ?? this.bookcase,
      bookImagePreview: bookImagePreview ?? this.bookImagePreview,
    );
  }

  
  @override
  String toString() => 'BookcaseDto(bookcase: $bookcase, bookImagePreview: $bookImagePreview)';

  @override
  bool operator ==(covariant BookcaseDto other) {
    if (identical(this, other)) return true;
  
    return 
      other.bookcase == bookcase &&
      other.bookImagePreview == bookImagePreview;
  }

  @override
  int get hashCode => bookcase.hashCode ^ bookImagePreview.hashCode;
}
