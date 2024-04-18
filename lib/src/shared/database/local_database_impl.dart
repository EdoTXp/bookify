import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseImpl implements LocalDatabase {
  Database? _database;
  final databaseScripts = DatabaseScripts();

  Future<Database?> get database async {
    if (_database != null) return _database;

    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      String path = join(
        databasesPath,
        databaseScripts.databaseName,
      );

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

    batch.execute(databaseScripts.bookScript);
    batch.execute(databaseScripts.categoryScript);
    batch.execute(databaseScripts.authorScript);
    batch.execute(databaseScripts.bookAuthorsScript);
    batch.execute(databaseScripts.bookCategoriesScript);
    batch.execute(databaseScripts.bookReadingScript);
    batch.execute(databaseScripts.loanScript);
    batch.execute(databaseScripts.bookcaseScript);
    batch.execute(databaseScripts.bookOnCaseScript);

    await batch.commit();
  }

  @override
  Future<List<Map<String, dynamic>>> getAll({
    required String table,
    String? orderColumn,
    OrderByType? orderBy,
  }) async {
    try {
      final db = await database;
      final queryItems = await db!.query(
        table,
        orderBy: (orderColumn != null && orderBy != null)
            ? '$orderColumn ${orderBy.orderToString()}'
            : null,
      );
      return queryItems;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getByJoin({
    required String table,
    required List<String> columns,
    required String innerJoinTable,
    required String onColumn,
    required String onArgs,
    required String whereColumn,
    required String whereArgs,
    bool usingLikeCondition = false,
  }) async {
    try {
      final db = await database;

      final whereCondition = usingLikeCondition ? 'LIKE' : '=';

      final query =
          'SELECT ${columns.join(', ')} FROM $table INNER JOIN $innerJoinTable ON $onColumn = $onArgs WHERE $whereColumn $whereCondition ?';

      final queryItems = await db!.rawQuery(
        query,
        [usingLikeCondition ? '%$whereArgs%' : whereArgs],
      );

      return queryItems;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getItemById({
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
  Future<List<Map<String, dynamic>>> getItemsByColumn({
    required String table,
    required String column,
    required dynamic columnValues,
    OrderByType? orderBy,
    int? limit,
  }) async {
    try {
      final db = await database;

      final queryItems = await db!.query(
        table,
        where: '$column = ?',
        whereArgs: [columnValues],
        orderBy: orderBy?.orderToString(),
        limit: limit,
      );

      if (queryItems.isEmpty) return [];

      return queryItems;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> researchBy({
    required String table,
    required String column,
    required String columnValues,
  }) async {
    try {
      final db = await database;

      final queryItems = await db!.query(
        table,
        where: '$column LIKE ?',
        whereArgs: ['%$columnValues%'],
      );

      if (queryItems.isEmpty) return [];

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

      final queryItems = await db!.query(
        table,
        columns: columns,
        where: '$idColumn = ?',
        whereArgs: [id],
      );

      if (queryItems.isEmpty) return {};

      return queryItems.first;
    } on DatabaseException catch (e) {
      throw LocalDatabaseException(e.toString());
    }
  }

  @override
  Future<int> insert({
    required String table,
    required Map<String, dynamic> values,
  }) async {
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
  Future<int> deleteWithAnotherColumn({
    required String table,
    required String otherColumn,
    required value,
    required String idColumn,
    required id,
  }) async {
    try {
      final db = await database;
      int rowCount = 0;

      await db!.transaction((txn) async {
        rowCount = await txn.delete(
          table,
          where: '$idColumn = ? AND $otherColumn = ?',
          whereArgs: [id, value],
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
