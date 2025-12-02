import 'dart:io';

import 'package:bookify/src/core/adapters/google_books_adapter.dart';
import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';

class GoogleBooksDataSourceImpl implements RemoteBooksDataSource {
  final RestClient _client;

  static const _baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';
  static const _urlParams =
      '&printType=books&orderBy=newest&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';

  GoogleBooksDataSourceImpl(this._client);

  @override
  Future<List<BookModel>> getAllBooks() => _fetch('_$_urlParams');

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) =>
      _fetch('intitle:$title$_urlParams');

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) =>
      _fetch('inauthor:$author$_urlParams');

  @override
  Future<List<BookModel>> findBooksByCategory({required String category}) =>
      _fetch('subject:$category$_urlParams');

  @override
  Future<List<BookModel>> findBooksByPublisher({required String publisher}) =>
      _fetch('inpublisher:$publisher$_urlParams');

  @override
  Future<List<BookModel>> findBooksByIsbn({required String isbn}) =>
      _fetch('isbn:$isbn$_urlParams');

  Future<List<BookModel>> _fetch(String urlParams) async {
    try {
      final response = await _client.get(
        baseUrl: _baseUrl,
        urlParams: urlParams,
      );
      final books = GoogleBooksAdapter.fromJsonList(response);

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
