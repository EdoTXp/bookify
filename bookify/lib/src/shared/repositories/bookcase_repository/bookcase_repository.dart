import 'package:bookify/src/shared/models/bookcase_model.dart';

abstract interface class BookcaseRepository {
  Future<int> insert({required BookcaseModel bookcaseModel});
  Future<List<BookcaseModel>> getAll();
  Future<BookcaseModel> getById({required int bookcaseId});
  Future<int> update({required BookcaseModel bookcaseModel});
  Future<int> delete({required int bookcaseId});
}
