import 'package:bookify/src/shared/models/bookcase_model.dart';

abstract interface class BookcaseService {
  Future<List<BookcaseModel>> getAllBookcases();
  Future<List<BookcaseModel>> getBookcasesByName({required String name});
  Future<BookcaseModel> getBookcaseById({required int bookcaseId});
  Future<List<Map<String, dynamic>>> getAllBookcaseRelationships({
    required int bookcaseId,
  });
  Future<int> deleteBookcaseRelationship({
    required int bookcaseId,
    required String bookId,
  });
  Future<int> insertBookcase({required BookcaseModel bookcaseModel});
  Future<int> insertBookcaseRelationship({
    required int bookcaseId,
    required String bookId,
  });
  Future<int> countBookcases();
  Future<int> countBookcasesByBook({required String bookId});
  Future<String?> getBookIdForImagePreview({required int bookcaseId});
  Future<int> updateBookcase({required BookcaseModel bookcaseModel});
  Future<int> deleteBookcase({required int bookcaseId});
}
