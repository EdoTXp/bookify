import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'remote_books_repository.dart';

class RemoteBooksRepositoryImpl implements RemoteBooksRepository {
  final RemoteBooksDataSource _booksDataSource;

  RemoteBooksRepositoryImpl(this._booksDataSource);

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) {
    return _booksDataSource.findBooksByAuthor(author: author);
  }

  @override
  Future<List<BookModel>> findBooksByIsbn({required String isbn}) {
    return _booksDataSource.findBooksByIsbn(isbn: isbn);
  }

  @override
  Future<List<BookModel>> findBooksByPublisher({required String publisher}) {
    return _booksDataSource.findBooksByPublisher(publisher: publisher);
  }

  @override
  Future<List<BookModel>> findBooksByCategory({required String category}) {
    return _booksDataSource.findBooksByCategory(category: category);
  }

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) {
    return _booksDataSource.findBooksByTitle(title: title);
  }

  @override
  Future<List<BookModel>> getAllBooks() {
    return _booksDataSource.getAllBooks();
  }
}
