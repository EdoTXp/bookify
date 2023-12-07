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
    final db = await database;
    final queryItems = await db!.query(table);
    return queryItems;
  }

  @override
  Future<Map<String, Object?>> getById({
    required String table,
    String? idName,
    required dynamic id,
  }) async {
    final db = await database;
    final conditionId = idName ?? 'id';

    final queryItem = await db!.query(
      table,
      where: '$conditionId = ?',
      whereArgs: [id],
    );
    return queryItem.first;
  }

  @override
  Future<int> insert(
      {required String table, required Map<String, dynamic> values}) async {
    final db = await database;
    int newId = 0;

    db!.transaction((txn) async {
      newId = await txn.insert(table, values);
    });

    return newId;
  }

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> values,
    String? idName,
    required dynamic id,
  }) async {
    final db = await database;
    final conditionId = idName ?? 'id';
    int changeMade = 0;

    db!.transaction((txn) async {
      changeMade = await txn.update(
        table,
        values,
        where: '$conditionId = ?',
        whereArgs: [id],
      );
    });

    return changeMade;
  }

  @override
  Future<int> delete({
    required String table,
    String? idName,
    required dynamic id,
  }) async {
    final db = await database;
    final conditionId = idName ?? 'id';
    int rowCount = 0;

    db!.transaction((txn) async {
      rowCount = await txn.delete(
        table,
        where: '$conditionId = ?',
        whereArgs: [id],
      );
    });

    return rowCount;
  }
}
