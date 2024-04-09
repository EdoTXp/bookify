///Get the name of database : bookify.db
String get databaseName => _databaseName;

//Table Names Getters
String get bookTableName => _bookTableName;
String get authorTableName => _authorTableName;
String get categoryTableName => _categoryTableName;
String get bookAuthorsTableName => _bookAuthorsTableName;
String get bookCategoriesTableName => _bookCategoriesTableName;
String get bookReadingTableName => _bookReadingTableName;
String get loanTableName => _loanTableName;
String get bookcaseTableName => _bookcaseTableName;
String get bookOnCaseTableName => _bookOnCaseTableName;

//Tables Scripts Getters
/// Create a table for [BookModel]
String get bookScript => _bookScript;

/// Create a table for [AuthorModel]
String get authorScript => _authorScript;

/// Create a table for [CategoryModel]
String get categoryScript => _categoryScript;

/// Create a table for relationship [BookModel] and [AuthorModel]
String get bookAuthorsScript => _bookAuthorsScript;

/// Create a table for relationship [BookModel] and [CategoryModel]
String get bookCategoriesScript => _bookCategoriesScript;

/// Create a table for relationship [BookModel] and [ReadingModel]
/// [lastReadingDate] is a millisSinceEpoch
String get bookReadingScript => _bookReadingScript;

/// Create a table for [LoanModel].
/// [loanDate] and [devolutionDate] is a millisSinceEpoch
/// [idContact] used to get the native contact on device.
/// A separate table has not been created for the contact.
/// This way you can take advantage of the contact changes without having to update them in this table.
String get loanScript => _loanScript;

/// Create a table for [BookCaseModel]
String get bookcaseScript => _bookCaseScript;

/// Create a table for relationship [BookModel] and [BookCaseModel]
String get bookOnCaseScript => _bookOnCaseScript;

const String _databaseName = 'bookify.db';

const String _bookTableName = 'book';
const String _authorTableName = 'author';
const String _categoryTableName = 'category';
const String _bookAuthorsTableName = 'bookAuthors';
const String _bookCategoriesTableName = 'bookCategories';
const String _bookReadingTableName = 'bookReading';
const String _loanTableName = 'loan';
const String _bookcaseTableName = 'bookcase';
const String _bookOnCaseTableName = 'bookOnCase';

const String _bookScript = '''
     CREATE TABLE $_bookTableName (
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

const String _authorScript = '''
    CREATE TABLE $_authorTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL
    )
    ''';

const String _categoryScript = '''
    CREATE TABLE $_categoryTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE  NOT NULL
    )
    ''';

const String _bookAuthorsScript = '''
     CREATE TABLE $_bookAuthorsTableName (
      bookId TEXT NOT NULL,
      authorId INTEGER NOT NULL,
      PRIMARY KEY (bookId, authorId),
      FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE CASCADE,
      FOREIGN KEY (authorId) REFERENCES author (id)
      )
    ''';

const String _bookCategoriesScript = '''
     CREATE TABLE $_bookCategoriesTableName (
      bookId TEXT NOT NULL,
      categoryId INTEGER NOT NULL,
      PRIMARY KEY (bookId, CategoryId),
      FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE CASCADE,
      FOREIGN KEY (categoryId) REFERENCES category (id)
      )
    ''';

const String _bookReadingScript = '''
     CREATE TABLE $_bookReadingTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pagesReaded INTEGER,
      lastReadingDate INTEGER NOT NULL,
      bookId TEXT UNIQUE NOT NULL,
      FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE CASCADE
      )
    ''';

const String _loanScript = '''
     CREATE TABLE $_loanTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      observation TEXT NOT NULL,
      loanDate INTEGER NOT NULL,  
      devolutionDate INTEGER NOT NULL,
      idContact TEXT NOT NULL,
      bookId TEXT UNIQUE NOT NULL,
      FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE CASCADE
      )
''';

const String _bookCaseScript = '''
     CREATE TABLE $_bookcaseTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL,
      description TEXT NOT NULL,
      color INTEGER NOT NULL
      )
    ''';

const String _bookOnCaseScript = '''
     CREATE TABLE $_bookOnCaseTableName (
      bookId TEXT NOT NULL,
      bookcaseId INTEGER NOT NULL,
      PRIMARY KEY (bookId, bookcaseId),
      FOREIGN KEY (bookId) REFERENCES book (id) ON DELETE CASCADE,
      FOREIGN KEY (bookcaseId) REFERENCES bookcase (id) ON DELETE CASCADE
      )
    ''';
