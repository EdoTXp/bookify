import 'package:bookify/src/shared/models/bookcase_model.dart';

abstract interface class BookcaseRepository {
  Future<List<BookcaseModel>> getAll();
  Future<List<BookcaseModel>> getBookcasesByName({required String name});
  Future<BookcaseModel> getById({required int bookcaseId});
  Future<int> insert({required BookcaseModel bookcaseModel});
  Future<int> update({required BookcaseModel bookcaseModel});
  Future<int> delete({required int bookcaseId});
}
