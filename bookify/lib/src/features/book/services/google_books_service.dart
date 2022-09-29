import '../adapters/google_books_adapter.dart';
import '../errors/book_error.dart';
import '../models/book_model.dart';

import 'interfaces/books_service_interface.dart';
import 'interfaces/http_service_interface.dart';

const _baseUrl = 'https://www.googleapis.com/books/v1/volumes?q=';
const _urlParams =
    '&download=epub&printType=books&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';
const _isbnUrlParams =
    '&fields=items(id, volumeInfo(title, authors, publisher, description, infoLink, pageCount, imageLinks/thumbnail, categories, averageRating, ratingsCount))&maxResults=40';

class GoogleBookService implements IBooksService {
  final IHttpService _service;

  GoogleBookService(this._service);

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) async {
    final url = '${_baseUrl}inauthor:$author$_urlParams';
    final books = await _responseBook(url);
    return books;
  }

  @override
  Future<BookModel> findBookByISBN({required int isbn}) async {
    final url = '${_baseUrl}isbn:$isbn$_isbnUrlParams';
    final books = await _responseBook(url);
    return books.last;
  }

  @override
  Future<List<BookModel>> findBooksByPublisher(
      {required String publisher}) async {
    final url = '${_baseUrl}inpublisher:$publisher$_urlParams';
    final books = await _responseBook(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByCategory(
      {required String category}) async {
    final url = '${_baseUrl}subject:$category$_urlParams';
    final books = await _responseBook(url);
    return books;
  }

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) async {
    final url = '${_baseUrl}intitle:$title$_urlParams';
    final books = await _responseBook(url);
    return books;
  }

  @override
  Future<List<BookModel>> getAllBooks() async {
    const url = '$_baseUrl*$_isbnUrlParams';
    final books = await _responseBook(url);
    return books;
  }

  @override
  void dispose() {
    _service.dispose();
  }

  Future<List<BookModel>> _responseBook(String url) async {
    try {
      final response = await _service.get(url);
      final books = (response['items'] as List)
          .map((bookMap) => GoogleBooksAdapter.fromJson(bookMap))
          .toList();

      return books;
    } catch (e) {
      throw BookException(e.toString());
    }
  }
}
