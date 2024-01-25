import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as book_on_case;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/repositories/book_on_case_repository/book_on_case_repository.dart';

class BookOnCaseRepositoryImpl implements BookOnCaseRepository {
  final LocalDatabase _database;
  final _bookOnCaseTableName = book_on_case.bookOnCaseTableName;

  BookOnCaseRepositoryImpl(this._database);

  @override
  Future<List<Map<String, dynamic>>> getBooksOnCaseRelationship({
    required int bookcaseId,
  }) async {
    try {
      final bookOnCaseRelationships = await _database.getItemsByColumn(
        table: _bookOnCaseTableName,
        column: 'bookcaseId',
        columnValues: bookcaseId,
      );

      return bookOnCaseRelationships;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<String?> getBookIdForImagePreview({required int bookcaseId}) async {
    try {
      final bookRelationshipMap = await _database.getColumnsById(
        table: _bookOnCaseTableName,
        columns: ['bookId'],
        idColumn: 'bookcaseId',
        id: bookcaseId,
      );

      final bookId = bookRelationshipMap['bookId'] as String?;
      return bookId;
    } on TypeError {
      throw LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required int bookcaseId, required String bookId}) async {
    try {
      final rowInserted =
          await _database.insert(table: _bookOnCaseTableName, values: {
        'bookId': bookId,
        'bookcaseId': bookcaseId,
      });

      return rowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int bookcaseId}) async {
    try {
      final rowDeleted = await _database.delete(
        table: _bookOnCaseTableName,
        idColumn: 'bookcaseId',
        id: bookcaseId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
