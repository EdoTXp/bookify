import '../models/book_model.dart';

abstract class IBooksRepository {
  Future<List<BookModel>> getAllBooks();

  Future<List<BookModel>> findBooksByAuthor({required String author});

  Future<List<BookModel>> findBooksByPublisher({required String publisher});

  Future<List<BookModel>> findBooksByCategory({required String category});

  Future<List<BookModel>> findBooksByTitle({required String title});

  Future<BookModel> findBookByISBN({required int isbn});

  void dispose();
}
