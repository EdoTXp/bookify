import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as database_script;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseImpl implements LocalDatabase {
  Database? _database;

  String get databaseName => database_script.databaseName;

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
    } on DatabaseException {
      rethrow;
    }
  }

  void _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    batch.execute(database_script.bookScript);
    batch.execute(database_script.categoryScript);
    batch.execute(database_script.authorScript);
    batch.execute(database_script.bookAuthorsScript);
    batch.execute(database_script.bookCategoriesScript);
    batch.execute(database_script.bookReadingScript);
    batch.execute(database_script.loanScript);
    batch.execute(database_script.peopleScript);
    batch.execute(database_script.loanToPeopleScript);
    batch.execute(database_script.bookLoanScript);
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
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<Map<String, Object?>> getById({
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
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert(
      {required String table, required Map<String, dynamic> values}) async {
    try {
      final db = await database;
      int newId = 0;

      db!.transaction((txn) async {
        newId = await txn.insert(table, values);
      });

      return newId;
    } on DatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getByColumn({
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
    } on DatabaseException {
      rethrow;
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
      int changeMade = 0;

      db!.transaction((txn) async {
        changeMade = await txn.update(
          table,
          values,
          where: '$idColumn = ?',
          whereArgs: [id],
        );
      });

      return changeMade;
    } on DatabaseException {
      rethrow;
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
      final queryMap = await db!.rawQuery(
          'SELECT COUNT(*) FROM $table WHERE $column = $columnValue');

      final itemFound = (queryMap.last.values.last as int);
      final itemIsInserted = (itemFound > 0);
      return itemIsInserted;
    } on DatabaseException {
      rethrow;
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

      db!.transaction((txn) async {
        rowCount = await txn.delete(
          table,
          where: '$idColumn = ?',
          whereArgs: [id],
        );
      });

      return rowCount;
    } on DatabaseException {
      rethrow;
    }
  }
}
