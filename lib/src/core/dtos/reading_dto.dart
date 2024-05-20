import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/reading_model.dart';

class ReadingDto {
  final ReadingModel reading;
  final BookModel book;

  const ReadingDto({
    required this.reading,
    required this.book,
  });

  int get percentReading =>
      ((reading.pagesReaded / book.pageCount) * 100).round();

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
