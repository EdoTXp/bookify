import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';

final booksModelMock = [
  BookModel(
    id: '1',
    title: 'title',
    authors: [AuthorModel(name: 'author')],
    publisher: 'publisher',
    description: 'description',
    categories: [CategoryModel(name: 'categories')],
    pageCount: 320,
    imageUrl: 'imageUrl',
    buyLink: 'buyLink',
    averageRating: 5.2,
    ratingsCount: 4,
  ),
  BookModel(
    id: '2',
    title: 'title',
    authors: [AuthorModel(name: 'author')],
    publisher: 'publisher',
    description: 'description',
    categories: [CategoryModel(name: 'categories')],
    pageCount: 157,
    imageUrl: 'imageUrl',
    buyLink: 'buyLink',
    averageRating: 0,
    ratingsCount: 0,
  ),
];
