import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';

class BookCategoriesRepositoryImpl implements BookCategoriesRepository {
  final LocalDatabase _database;
  final _bookCategoriesTableName = DatabaseScripts().bookCategoriesTableName;

  BookCategoriesRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getRelationshipsById({
    required String bookId,
  }) async {
    try {
      final bookCategoriesRelationships = await _database.getItemsByColumn(
        table: _bookCategoriesTableName,
        column: 'bookId',
        columnValues: bookId,
      );

      if (bookCategoriesRelationships.last.isEmpty) {
        throw const LocalDatabaseException('Impossível buscar os dados');
      }

      return bookCategoriesRelationships;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required String bookId, required int categoryId}) async {
    try {
      final rowInserted =
          await _database.insert(table: _bookCategoriesTableName, values: {
        'bookId': bookId,
        'categoryId': categoryId,
      });

      return rowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required String bookId}) async {
    try {
      final rowDeleted = await _database.delete(
        table: _bookCategoriesTableName,
        idColumn: 'bookId',
        id: bookId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
