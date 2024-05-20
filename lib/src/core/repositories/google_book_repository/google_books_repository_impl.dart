import 'dart:io';
import 'package:bookify/src/core/adapters/google_books_adapter.dart';
import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';

import 'package:bookify/src/core/models/book_model.dart';

import 'google_books_repository.dart';

/// Parameters used to return an optimised and filtered JSON with the data needed to instantiate the [BookModel] class.
const _urlParams =
    '&printType=books&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';

class GoogleBookRepositoryImpl implements GoogleBooksRepository {
  final RestClient _httpSource;

  GoogleBookRepositoryImpl(this._httpSource);

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) async {
    final url = 'inauthor:$author$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByIsbn({required String isbn}) async {
    final url = 'isbn:$isbn$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByPublisher(
      {required String publisher}) async {
    final url = 'inpublisher:$publisher$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByCategory(
      {required String category}) async {
    final url = 'subject:$category$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) async {
    final url = 'intitle:$title$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> getAllBooks() async {
    const url = '*$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  Future<List<BookModel>> _fetch(String url) async {
    try {
      final response = await _httpSource.get(url);
      final books = (response['items'] as List)
          .map((bookMap) => GoogleBooksAdapter.fromJson(bookMap))
          .toList();

      return books;
    } on TypeError {
      return <BookModel>[];
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
