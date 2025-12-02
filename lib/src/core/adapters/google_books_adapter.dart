import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/category_model.dart';

import 'package:bookify/src/core/models/book_model.dart';

/// Class that returns a [BookModel] adapting all data that the Google Books API returns NULL.
abstract class GoogleBooksAdapter {
  GoogleBooksAdapter._();

  /// This method handles the entire JSON list response from the API.
  /// It extracts the 'items' and uses [fromJson] for each book.
  static List<BookModel> fromJsonList(Map<String, dynamic> json) {
    if (json['items'] == null) {
      return [];
    }
    return (json['items'] as List)
        .map((bookMap) => fromJson(bookMap))
        .toList();
  }

  /// This method was extracted from the [BookModel] class in order to ensure that if one were to change the book API,
  /// one would only have to create another Adapter class for this new API
  static BookModel fromJson(Map map) {
    return BookModel(
      id: map['id'],
      title: map['volumeInfo']['title'],
      authors:
          List<String>.from(map['volumeInfo']['authors'] ?? ['Unknown Author'])
              .map((author) => AuthorModel(name: author))
              .toList(),
      publisher: map['volumeInfo']['publisher'] ?? 'Unknown Publisher',
      description:
          map['volumeInfo']['description'] ?? 'No description available',
      categories: List<String>.from(
              map['volumeInfo']['categories'] ?? ['Unknown category'])
          .map((category) => CategoryModel(name: category))
          .toList(),
      pageCount: map['volumeInfo']['pageCount'] ?? 0,
      imageUrl: (map['volumeInfo']['imageLinks']?['thumbnail'] ??
          'https://books.google.com.br/googlebooks/images/no_cover_thumb.gif'),
      buyLink: map['volumeInfo']['infoLink'] ??
          'https://play.google.com/store/books?',
      averageRating: (map['volumeInfo']['averageRating'] ?? 0.0).toDouble(),
      ratingsCount: map['volumeInfo']['ratingsCount'] ?? 0,
    );
  }
}
