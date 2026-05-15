import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/repositories/books_repository/books_repository.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';

class BooksRepositoryImpl implements BooksRepository {
  final LocalDatabase _database;
  final _bookTableName = DatabaseScripts().bookTableName;

  BooksRepositoryImpl(this._database);

  @override
  Future<List<BookModel>> getAll() async {
    try {
      final booksMap = await _database.getAll(table: _bookTableName);
      final booksModel = booksMap.map(BookModel.fromMap).toList();
      return booksModel;
    } on TypeError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<BookModel> getBookById({required String id}) async {
    try {
      final bookMap = await _database.getItemById(
        table: _bookTableName,
        idColumn: 'id',
        id: id,
      );

      final bookModel = BookModel.fromMap(bookMap);
      return bookModel;
    } on TypeError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required BookModel bookModel}) async {
    try {
      final rowInserted = await _database.insert(
        table: _bookTableName,
        values: bookModel.toMap(),
      );
      return rowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<String> getBookImageById({required String id}) async {
    try {
      final imageMap = await _database.getColumnsById(
        table: _bookTableName,
        columns: ['imageUrl'],
        idColumn: 'id',
        id: id,
      );

      final bookImage = imageMap['imageUrl'] as String;
      return bookImage;
    } on TypeError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getBooksByTitle({required String title}) async {
    try {
      final booksMap = await _database.researchBy(
        table: _bookTableName,
        column: 'title',
        columnValues: title,
      );
      final books = booksMap.map(BookModel.fromMap).toList();

      return books;
    } on TypeError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<bool> verifyBookIsAlreadyInserted({required String id}) async {
    try {
      final isBookInserted = await _database.verifyItemIsAlreadyInserted(
        table: _bookTableName,
        column: 'id',
        columnValue: id,
      );
      return isBookInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<BookStatus> getBookStatus({required String id}) async {
    try {
      final statusMap = await _database.getColumnsById(
        table: _bookTableName,
        columns: ['status'],
        idColumn: 'id',
        id: id,
      );

      final bookStatus = BookStatus.fromMap(statusMap['status'] as int);
      return bookStatus!;
    } on TypeError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> updateBookStatus({
    required String id,
    required BookStatus status,
  }) async {
    try {
      final bookRowStatusUpdate = await _database.update(
        table: _bookTableName,
        idColumn: 'id',
        id: id,
        values: {'status': status.statusNumber},
      );

      return bookRowStatusUpdate;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> updateBookPageCount({
    required String id,
    required int pageCount,
  }) async {
    try {
      assert(pageCount > 0, 'pagesCount must be greater than 0');

      final bookPagesCountUpdate = await _database.update(
        table: _bookTableName,
        idColumn: 'id',
        id: id,
        values: {'pageCount': pageCount},
      );

      return bookPagesCountUpdate;
    } on LocalDatabaseException {
      rethrow;
    } on AssertionError catch (e) {
      throw LocalDatabaseException(
        LocalDatabaseErrorCode.invalidData,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<int> countBooks() async {
    try {
      final booksCount = await _database.countItems(
        table: _bookTableName,
      );

      return booksCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteBookById({required String id}) async {
    try {
      final rowDeleted = await _database.delete(
        table: _bookTableName,
        idColumn: 'id',
        id: id,
      );
      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
