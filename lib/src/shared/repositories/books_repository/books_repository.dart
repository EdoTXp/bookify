import 'package:bookify/src/shared/models/book_model.dart';

abstract interface class BooksRepository {
  Future<List<BookModel>> getAll();
  Future<BookModel> getBookById({required String id});
  Future<String> getBookImageById({required String id});
  Future<List<BookModel>> getBooksByTitle({required String title});
  Future<int> insert({required BookModel bookModel});
  Future<bool> verifyBookIsAlreadyInserted({required String id});
  Future<BookStatus>getBookStatus({required String id});
  Future<int> updateBookStatus({required String id, required BookStatus status});
  Future<int> updateBookPageCount({required String id, required int pageCount});
  Future<int> deleteBookById({required String id});
}
