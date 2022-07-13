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
  final double averageRating;
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
    required this.averageRating,
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
    double? averageRating,
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
      averageRating: averageRating ?? this.averageRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
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
        averageRating.hashCode;
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
        other.averageRating == averageRating;
  }
}
