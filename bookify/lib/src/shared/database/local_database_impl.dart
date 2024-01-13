import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as database_script;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseImpl implements LocalDatabase {
  Database? _database;
  String databaseName = database_script.databaseName;

  Future<Database?> get database async {
    if (_database != null) return _database;

    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName);

      return await openDatabase(
        path,
        onCreate: _onCreate,
        onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        version: 1,
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    batch.execute(database_script.bookScript);
    batch.execute(database_script.categoryScript);
    batch.execute(database_script.authorScript);
    batch.execute(database_script.bookAuthorsScript);
    batch.execute(database_script.bookCategoriesScript);
    batch.execute(database_script.bookReadingScript);
    batch.execute(database_script.loanScript);
    batch.execute(database_script.bookcaseScript);
    batch.execute(database_script.bookOnCaseScript);

    await batch.commit();
  }

  @override
  Future<List<Map<String, Object?>>> getAll({required String table}) async {
    try {
      final db = await database;
      final queryItems = await db!.query(table);
      return queryItems;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<Map<String, Object?>> getItemById({
    required String table,
    required String idColumn,
    required dynamic id,
  }) async {
    try {
      final db = await database;

      final queryItem = await db!.query(
        table,
        where: '$idColumn = ?',
        whereArgs: [id],
      );
      return queryItem.first;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getItemByColumn({
    required String table,
    required String column,
    required columnValues,
  }) async {
    try {
      final db = await database;

      final queryItems = await db!.query(
        table,
        where: '$column = ?',
        whereArgs: [columnValues],
      );
      return queryItems;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getColumnsById({
    required String table,
    List<String>? columns,
    required String idColumn,
    required id,
  }) async {
    try {
      final db = await database;

      final queryItem = await db!.query(
        table,
        columns: columns,
        where: '$idColumn = ?',
        whereArgs: [id],
      );
      return queryItem.first;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<int> insert(
      {required String table, required Map<String, dynamic> values}) async {
    try {
      final db = await database;
      int newId = 0;

      await db!.transaction((txn) async {
        newId = await txn.insert(table, values);
      });

      return newId;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> values,
    required String idColumn,
    required dynamic id,
  }) async {
    try {
      final db = await database;
      int rowUpdated = 0;

      await db!.transaction((txn) async {
        rowUpdated = await txn.update(
          table,
          values,
          where: '$idColumn = ?',
          whereArgs: [id],
        );
      });

      return rowUpdated;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<bool> verifyItemIsAlreadyInserted({
    required String table,
    required String column,
    required dynamic columnValue,
  }) async {
    try {
      final db = await database;
      final queryMap = await db!
          .query(table, where: '$column = ?', whereArgs: [columnValue]);

      final itemFound = queryMap.isNotEmpty;
      return itemFound;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<int> delete({
    required String table,
    required String idColumn,
    required dynamic id,
  }) async {
    try {
      final db = await database;
      int rowCount = 0;

      await db!.transaction((txn) async {
        rowCount = await txn.delete(
          table,
          where: '$idColumn = ?',
          whereArgs: [id],
        );
      });

      return rowCount;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<void> closeDatabase() async {
    try {
      final db = await database;
      await db!.close();
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }
}
