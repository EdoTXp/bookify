import 'package:bookify/src/shared/database/local_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseImpl implements LocalDatabase {
  static Database? _database;
  static const String _databaseName = 'bookify.db';

  static String get databaseName => _databaseName;

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

    batch.execute(_bookScript);
    batch.execute(_categoryScript);
    batch.execute(_authorScript);
    batch.execute(_bookAuthorsScript);
    batch.execute(_bookCategoriesScript);
    batch.execute(_bookReadingScript);
    batch.execute(_loanScript);
    batch.execute(_peopleScript);
    batch.execute(_loanToPeopleScript);
    batch.execute(_bookLoanScript);
    batch.execute(_bookCaseScript);
    batch.execute(_bookOnCaseScript);

    await batch.commit();
  }

  @override
  Future<List<Map<String, Object?>>> getAll({required String table}) async {
    final db = await database;
    final queryItems = await db!.query(table);
    return queryItems;
  }

  @override
  Future<Map<String, Object?>> getById(
      {required String table, required dynamic id}) async {
    final db = await database;
    final queryItem = await db!.query(table, where: 'id = ?', whereArgs: [id]);
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
  Future<int> update(
      {required String table,
      required Map<String, dynamic> values,
      required dynamic id}) async {
    final db = await database;
    int changeMade = 0;

    db!.transaction((txn) async {
      changeMade =
          await txn.update(table, values, where: 'id = ?', whereArgs: [id]);
    });

    return changeMade;
  }

  @override
  Future<int> delete({required String table, required dynamic id}) async {
    final db = await database;
    int rowCount = 0;

    db!.transaction((txn) async {
      rowCount = await txn.delete(table, where: 'id = ?', whereArgs: [id]);
    });

    return rowCount;
  }
}

/// Create a table for [BookModel]
const String _bookScript = '''
     CREATE TABLE book (
      id TEXT UNIQUE NOT NULL PRIMARY KEY,
      title TEXT NOT NULL,
      publisher TEXT NOT NULL,
      description TEXT NOT NULL,
      pageCount INTEGER NOT NULL,
      imageUrl TEXT NOT NULL,
      buyLink TEXT NOT NULL,
      averageRating REAL NOT NULL,
      ratingsCount INTEGER NOT NULL,
      status INTEGER NOT NULL
      )
''';

/// Create a table for [AuthorModel]
const String _authorScript = '''
    CREATE TABLE author (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL
    )
    ''';

/// Create a table for [CategoryModel]
const String _categoryScript = '''
    CREATE TABLE category (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE  NOT NULL
    )
    ''';

/// Create a table for relationship [BookModel] and [AuthorModel]
const String _bookAuthorsScript = '''
     CREATE TABLE bookAuthors (
      bookId TEXT,
      authorId INTEGER,
      FOREIGN KEY (bookId) REFERENCES book (id),
      FOREIGN KEY (authorId) REFERENCES author (id)
      ON DELETE CASCADE
      )
    ''';

/// Create a table for relationship [BookModel] and [CategoryModel]
const String _bookCategoriesScript = '''
     CREATE TABLE bookCategories (
      bookId TEXT,
      categoryId INTEGER,
      FOREIGN KEY (bookId) REFERENCES book (id),
      FOREIGN KEY (categoryId) REFERENCES category (id)
      ON DELETE CASCADE
      )
    ''';

/// Create a table for relationship [BookModel] and [ReadingModel] last_reading_date is a millisSinceEpoch
const String _bookReadingScript = '''
     CREATE TABLE bookReading(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pagesReaded INTEGER,
      lastReading_date INTEGER,
      bookId TEXT,
      FOREIGN KEY (bookId) REFERENCES book (id)
      )
    ''';

/// Create a table for [LoanModel]. loan_date and devolution_date is a millisSinceEpoch
const String _loanScript = '''
     CREATE TABLE loan (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      observation TEXT,
      loanDate INTEGER,  
      devolutionDate INTEGER
      )
''';

/// Create a table for [PeopleModel].
const String _peopleScript = '''
     CREATE TABLE people (
      mobileNumber TEXT PRIMARY KEY UNIQUE,
      name TEXT
      )
''';

/// Create a table for [PeopleModel].
const String _loanToPeopleScript = '''
     CREATE TABLE loanToPerson (
      loanId INTEGER,
      peopleId TEXT,
      FOREIGN KEY (loanId) REFERENCES loan (id),
      FOREIGN KEY (peopleId) REFERENCES people (mobileNumber)
      )
''';

/// Create a table for relationship [BookModel] and [LoanModel]
const String _bookLoanScript = '''
     CREATE TABLE bookLoan (
      bookId TEXT,
      loanId INTEGER,
      FOREIGN KEY (bookId) REFERENCES book (id),
      FOREIGN KEY (loanId) REFERENCES loan (id)
      )
    ''';

/// Create a table for [BookCaseModel]
const String _bookCaseScript = '''
     CREATE TABLE bookcase (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      color INTEGER
      )
    ''';

/// Create a table for relationship [BookModel] and [BookCaseModel]
const String _bookOnCaseScript = '''
     CREATE TABLE bookOnCase (
      bookId TEXT,
      bookcaseId INTEGER,
      FOREIGN KEY (bookId) REFERENCES book (id),
      FOREIGN KEY (bookcaseId) REFERENCES bookcase (id)
      )
    ''';

