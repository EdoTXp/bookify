import 'package:bookify/src/core/models/author_model.dart';

abstract interface class AuthorsRepository {
  Future<AuthorModel> getAuthorById({required int id});
  Future<int> insert({required AuthorModel authorModel});
  Future<int> getAuthorIdByColumnName({required String authorName});
  Future<int> deleteAuthorById({required int id});
}
