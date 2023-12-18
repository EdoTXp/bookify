import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as book_authors;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository.dart';

class BookAuthorsRepositoryImpl implements BookAuthorsRepository {
  final LocalDatabase _database;
  final _bookAuthorsTableName = book_authors.bookAuthorsTableName;

  BookAuthorsRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getRelationshipsById({
    required String bookId,
  }) async {
    final bookAuthorsRelationships = await _database.getByColumn(
      table: _bookAuthorsTableName,
      column: 'bookId',
      columnValues: bookId,
    );

    return bookAuthorsRelationships;
  }

  @override
  Future<int> insert({required String bookId, required int authorId}) async {
    final rowInserted =
        await _database.insert(table: _bookAuthorsTableName, values: {
      'bookId': bookId,
      'authorId': authorId,
    });

    return rowInserted;
  }

  @override
  Future<int> delete({required String bookId}) async {
    final rowDeleted = await _database.delete(
      table: _bookAuthorsTableName,
      idColumn: 'bookId',
      id: bookId,
    );

    return rowDeleted;
  }
}
