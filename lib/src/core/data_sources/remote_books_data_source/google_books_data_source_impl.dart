import 'package:bookify/src/core/adapters/google_books_adapter.dart';
import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:bookify/src/core/enums/rest_client_error_code.dart';
import 'package:bookify/src/core/errors/rest_client_exception/rest_client_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';

class GoogleBooksDataSourceImpl implements RemoteBooksDataSource {
  final RestClient _client;
  final String _googleBooksApiKey;

  const GoogleBooksDataSourceImpl(
    this._client,
    this._googleBooksApiKey,
  );

  @override
  Future<List<BookModel>> getAllBooks() => _fetch('_');

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) =>
      _fetch('intitle:$title');

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) =>
      _fetch('inauthor:$author');

  @override
  Future<List<BookModel>> findBooksByCategory({required String category}) =>
      _fetch('subject:$category');

  @override
  Future<List<BookModel>> findBooksByPublisher({required String publisher}) =>
      _fetch('inpublisher:$publisher');

  @override
  Future<List<BookModel>> findBooksByIsbn({required String isbn}) =>
      _fetch('isbn:$isbn');

  Future<List<BookModel>> _fetch(String query) async {
    try {
      final response = await _client.get(
        baseUrl: 'https://www.googleapis.com/books/v1/volumes',
        queryParameters: {
          'q': query,
          'printType': 'books',
          'orderBy': 'newest',
          'fields':
              'items(id,volumeInfo(title,authors,publisher,description,infoLink,pageCount,imageLinks/thumbnail,categories,averageRating,ratingsCount))',
          'maxResults': 40,
          'key': _googleBooksApiKey,
        },
      );
      final books = GoogleBooksAdapter.fromJsonList(response);

      return books;
    } on TypeError {
      return <BookModel>[];
    } on RestClientException {
      rethrow;
    } catch (e) {
      throw RestClientException(
        RestClientErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
