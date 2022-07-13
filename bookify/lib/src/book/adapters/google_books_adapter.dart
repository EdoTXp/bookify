import 'package:bookify/src/book/models/book_model.dart';

class GoogleBooksAdapter {
  static BookModel fromJson(Map map) {
    return BookModel(
      id: map['id'],
      title: map['volumeInfo']['title'],
      authors:
          List<String>.from(map['volumeInfo']['authors'] ?? ['Nenhum Autor']),
      publisher: map['volumeInfo']['publisher'] ?? 'Nenhuma Editora',
      description: map['volumeInfo']['description'] ?? 'Não contém descrição',
      categories: List<String>.from(
          map['volumeInfo']['categories'] ?? ['Nenhum Gênero']),
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
