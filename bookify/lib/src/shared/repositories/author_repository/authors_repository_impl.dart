import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as author_table;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository.dart';

class AuthorsRepositoryImpl implements AuthorsRepository {
  final LocalDatabase _database;
  final _authorTableName = author_table.authorTableName;

  AuthorsRepositoryImpl(this._database);

  @override
  Future<AuthorModel> getAuthorById({required int id}) async {
    try {
      final authorsMap = await _database.getItemById(
        table: _authorTableName,
        idColumn: 'id',
        id: id,
      );

      final authorModel = AuthorModel.fromMap(authorsMap);
      return authorModel;
    } on TypeError {
      throw LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  /// Try looking to see if the book is already included.
  /// From the search, it returns the ID. Returns [-1] if the search found no author.
  @override
  Future<int> getAuthorIdByColumnName({required String authorName}) async {
    try {
      final authorMap = await _database.getItemsByColumn(
        table: _authorTableName,
        column: 'name',
        columnValues: authorName,
      );

      if (authorMap.isEmpty) {
        return -1;
      }

      final actualAuthorId = authorMap.last['id'] as int;
      return actualAuthorId;
    } on TypeError {
      throw LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required AuthorModel authorModel}) async {
    try {
      final authorId = await _database.insert(
        table: _authorTableName,
        values: authorModel.toMap(),
      );
      return authorId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteAuthorById({required int id}) async {
    try {
      final deletedRow = await _database.delete(
        table: _authorTableName,
        idColumn: 'id',
        id: id,
      );

      return deletedRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
