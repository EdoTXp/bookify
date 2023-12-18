import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as book_categories;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';

class BookCategoriesRepositoryImpl implements BookCategoriesRepository {
  final LocalDatabase _database;
  final _bookCategoriesTableName = book_categories.bookCategoriesTableName;

  BookCategoriesRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getRelationshipsById({
    required String bookId,
  }) async {
    final bookCategoriesRelationships = await _database.getByColumn(
      table: _bookCategoriesTableName,
      column: 'bookId',
      columnValues: bookId,
    );

    return bookCategoriesRelationships;
  }

  @override
  Future<int> insert({required String bookId, required int categoryId}) async {
    final rowInserted =
        await _database.insert(table: _bookCategoriesTableName, values: {
      'bookId': bookId,
      'authorId': categoryId,
    });

    return rowInserted;
  }

  @override
  Future<int> delete({required String bookId}) async {
    final rowDeleted = await _database.delete(
      table: _bookCategoriesTableName,
      idColumn: 'bookId',
      id: bookId,
    );

    return rowDeleted;
  }
}
