class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String description;
  final List<String> categories;
  final int pageCount;
  final String imageUrl;
  final String buyLink;
  final double averangeRating;
  final int ratingsCount;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.description,
    required this.categories,
    required this.pageCount,
    required this.imageUrl,
    required this.buyLink,
    required this.averangeRating,
    required this.ratingsCount,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? publisher,
    String? description,
    List<String>? categories,
    int? pageCount,
    String? imageUrl,
    String? buyLink,
    double? averangeRating,
    int? ratingsCount,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publisher: publisher ?? this.publisher,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      pageCount: pageCount ?? this.pageCount,
      imageUrl: imageUrl ?? this.imageUrl,
      buyLink: buyLink ?? this.buyLink,
      averangeRating: averangeRating ?? this.averangeRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
    );
  }

  factory BookModel.fromJson(Map map) {
    // Check if it is null because the Google Books API does not always return a complete book.
    return BookModel(
      id: map['id'],
      title: map['volumeInfo']['title'],
      authors: List<String>.generate(
          (map['volumeInfo']['authors'] ?? List.empty()).length,
          (index) => map['volumeInfo']['authors'][index] ?? 'Nenhum Autor'),
      publisher: map['volumeInfo']['publisher'] ?? 'Nenhuma Editora',
      description: map['volumeInfo']['description'] ?? 'Não contém descrição',
      categories: List<String>.generate(
          ((map['volumeInfo']['categories'] ?? List.empty()).length),
          (index) => map['volumeInfo']['categories'][index]),
      pageCount: map['volumeInfo']['pageCount'] ?? 0,
      imageUrl: (map['volumeInfo']['imageLinks']?['thumbnail'] ??
          'https://books.google.com.br/googlebooks/images/no_cover_thumb.gif'),
      buyLink: map['volumeInfo']['infoLink'] ??
          'https://play.google.com/store/books?',
      averangeRating: (map['volumeInfo']['averageRating'] ?? 0.0).toDouble(),
      ratingsCount: map['volumeInfo']['ratingsCount'] ?? 0,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        authors.hashCode ^
        publisher.hashCode ^
        description.hashCode ^
        categories.hashCode ^
        pageCount.hashCode ^
        imageUrl.hashCode ^
        buyLink.hashCode ^
        averangeRating.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookModel &&
        other.id == id &&
        other.title == title &&
        other.authors == authors &&
        other.publisher == publisher &&
        other.description == description &&
        other.categories == categories &&
        other.pageCount == pageCount &&
        other.imageUrl == imageUrl &&
        other.buyLink == buyLink &&
        other.averangeRating == averangeRating;
  }
}
