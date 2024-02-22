import 'package:bookify/src/shared/models/book_model.dart';

abstract interface class BookService {
  Future<List<BookModel>> getAllBook();
  Future<BookModel> getBookById({required String id});
  Future<List<BookModel>> getBookByTitle({required String title});
  Future<bool> verifyBookIsAlreadyInserted({required String id});
  Future<int> insertCompleteBook({required BookModel bookModel});
  Future<String> getBookImage({required String id});
  Future<int> updateStatus({required String id, required BookStatus status});
  Future<int> deleteBook({required String id});
}
