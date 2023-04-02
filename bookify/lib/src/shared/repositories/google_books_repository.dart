import 'dart:io';

import '../adapters/google_books_adapter.dart';
import '../errors/book_error/book_error.dart';
import '../models/book_model.dart';

import '../interfaces/books_repository_interface.dart';
import '../interfaces/http_client_interface.dart';

const _baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';

/// Parameters used to return an optimised and filtered JSON with the data needed to instantiate the [BookModel] class.
const _urlParams =
    '&download=epub&printType=books&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';

/// Parameters used to return an optimised and filtered JSON with the data needed to instantiate the [BookModel] class.
const _isbnUrlParams =
    '&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';

class GoogleBookRepository implements IBooksRepository {
  final IHttpClient _httpSource;

  GoogleBookRepository(this._httpSource);

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) async {
    final url = '${_baseUrl}inauthor:$author$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<BookModel> findBookByISBN({required int isbn}) async {
    final url = '${_baseUrl}isbn:$isbn$_isbnUrlParams';
    final books = await _fetch(url);
    return books.last;
  }

  @override
  Future<List<BookModel>> findBooksByPublisher(
      {required String publisher}) async {
    final url = '${_baseUrl}inpublisher:$publisher$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByCategory(
      {required String category}) async {
    final url = '${_baseUrl}subject:$category$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) async {
    final url = '${_baseUrl}intitle:$title$_urlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  Future<List<BookModel>> getAllBooks() async {
    const url = '$_baseUrl*$_isbnUrlParams';
    final books = await _fetch(url);
    return books;
  }

  @override
  void dispose() {
    _httpSource.dispose();
  }

  Future<List<BookModel>> _fetch(String url) async {
    try {
      final response = await _httpSource.get(url);
      final books = (response['items'] as List)
          .map((bookMap) => GoogleBooksAdapter.fromJson(bookMap))
          .toList();

      return books;
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
