import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';

enum BookStatus {
  library,
  reading,
  loaned;

  int get statusNumber {
    return switch (this) {
      BookStatus.library => 1,
      BookStatus.reading => 2,
      BookStatus.loaned => 3
    };
  }

  static BookStatus? fromMap(int value) {
    switch (value) {
      case 1:
        return BookStatus.library;
      case 2:
        return BookStatus.reading;
      case 3:
        return BookStatus.loaned;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return switch (this) {
      BookStatus.library => 'na estante',
      BookStatus.reading => 'em leitura',
      BookStatus.loaned => 'em empréstimo',
    };
  }
}

class BookModel {
  final String id;
  final String title;
  final List<AuthorModel> authors;
  final String publisher;
  final String description;
  final List<CategoryModel> categories;
  final int pageCount;
  final String imageUrl;
  final String buyLink;
  final double averageRating;
  final int ratingsCount;
  final BookStatus? status;

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
    this.status,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<AuthorModel>? authors,
    String? publisher,
    String? description,
    List<CategoryModel>? categories,
    int? pageCount,
    String? imageUrl,
    String? buyLink,
    double? averageRating,
    int? ratingsCount,
    BookStatus? status,
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
      status: status ?? this.status,
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
        averageRating.hashCode ^
        status.hashCode;
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
        other.averageRating == averageRating &&
        other.status == status;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'publisher': publisher,
      'description': description,
      'pageCount': pageCount,
      'imageUrl': imageUrl,
      'buyLink': buyLink,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'status': status?.statusNumber ?? 1,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as String,
      title: map['title'] as String,
      authors: List<AuthorModel>.from(
        (map['authors'] as dynamic ?? <AuthorModel>[]).map<AuthorModel>(
          (author) => AuthorModel.fromMap(author as Map<String, dynamic>),
        ),
      ),
      publisher: map['publisher'] as String,
      description: map['description'] as String,
      categories: List<CategoryModel>.from(
        (map['categories'] as dynamic ?? <CategoryModel>[]).map<CategoryModel>(
          (category) => CategoryModel.fromMap(category as Map<String, dynamic>),
        ),
      ),
      pageCount: map['pageCount'] as int,
      imageUrl: map['imageUrl'] as String,
      buyLink: map['buyLink'] as String,
      averageRating: map['averageRating'] as double,
      ratingsCount: map['ratingsCount'] as int,
      status: BookStatus.fromMap(map['status'] as int),
    );
  }

  @override
  String toString() {
    return '''
    id: $id,
    title: $title,
    authors: ${authors.map((author) => author.toString())}
    publisher: $publisher,
    categories: ${categories.map((category) => category.toString())}
    description: $description,
    pageCount: $pageCount,
    imageUrl: $imageUrl,
    buyLink: $buyLink,
    averageRating: $averageRating,
    ratingsCount: $ratingsCount,
    status: $status,
''';
  }
}
