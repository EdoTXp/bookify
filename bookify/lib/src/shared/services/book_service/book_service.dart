import 'package:bookify/src/shared/models/book_model.dart';

abstract interface class BookService {
  Future<bool> verifyBookIsAlreadyInserted({required String id});
  Future<void> insertCompleteBook({required BookModel bookModel});
  //Future<int> updateStatus({required BookStatus status});
  Future<int> deleteBook({required String id});
}
