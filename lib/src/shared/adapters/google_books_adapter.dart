import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';

import 'package:bookify/src/shared/models/book_model.dart';

/// Class that returns a [BookModel] adapting all data that the Google Books API returns NULL.
class GoogleBooksAdapter {
  /// This method was extracted from the [BookModel] class in order to ensure that if one were to change the book API,
  /// one would only have to create another Adapter class for this new API
  static BookModel fromJson(Map map) {
    return BookModel(
      id: map['id'],
      title: map['volumeInfo']['title'],
      authors:
          List<String>.from(map['volumeInfo']['authors'] ?? ['Nenhum Autor'])
              .map((author) => AuthorModel(name: author))
              .toList(),
      publisher: map['volumeInfo']['publisher'] ?? 'Nenhuma Editora',
      description: map['volumeInfo']['description'] ?? 'Não contém descrição.',
      categories: List<String>.from(
              map['volumeInfo']['categories'] ?? ['Nenhum Gênero'])
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
