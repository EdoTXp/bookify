import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/reading_model.dart';

class ReadingDto {
  final ReadingModel reading;
  final BookModel book;
  ReadingDto({
    required this.reading,
    required this.book,
  });

  ReadingDto copyWith({
    ReadingModel? reading,
    BookModel? book,
  }) {
    return ReadingDto(
      reading: reading ?? this.reading,
      book: book ?? this.book,
    );
  }

  @override
  String toString() => 'ReadingDto(reading: $reading, book: $book)';

  @override
  bool operator ==(covariant ReadingDto other) {
    if (identical(this, other)) return true;

    return other.reading == reading && other.book == book;
  }

  @override
  int get hashCode => reading.hashCode ^ book.hashCode;
}
