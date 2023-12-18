import 'package:bookify/src/shared/models/book_model.dart';

abstract interface class BooksRepository {
  Future<List<BookModel>> getAll();
  Future<BookModel> getBookById({required String id});
  Future<int> insert({required BookModel bookModel});
  Future<bool> verifyBookIsAlreadyInserted({required String id});
  Future<int> deleteBookById({required String id});
}
