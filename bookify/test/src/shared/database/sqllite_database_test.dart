import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../mocks/models/books_model_mock.dart';

/// These tests are used to prove whether the table logic and SQL scripts work correctly.
void main() {
  late Database database;

  /// From booksModelMocks : ../../mocks/models/books_model_mock.dart
  final bookModel = booksModelMock.first;

  setUp(() async {
    // Initialize FFI and open database
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);

    final batch = database.batch();

    // Enable foreign_keys
    batch.execute('PRAGMA foreign_keys = ON');

    // Execute all tables scripts
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
  });

  tearDown(() async {
    await database.close();
  });

  group('test insertion of all tables.', () {
    test('tests whether the entered book can be searched.', () async {
      // inserts a book into the 'book' table and expects there to be a row added.
      final row = await database.insert('book', bookModel.toMap());
      expect(row, equals(1));

      // runs a query to retrieve the book and turns it into a BookModel
      final bookJson = await database
          .query('book', where: 'id = ?', whereArgs: [bookModel.id]);
      var bookFromTable = BookModel.fromMap(bookJson.first);

      // add the authors and categories to be able to compare with the BookModel passed before.
      bookFromTable = bookFromTable.copyWith(
          authors: bookModel.authors, categories: bookModel.categories);

      expect(bookFromTable.id, bookModel.id);
      expect(bookFromTable.title, bookModel.title);
      expect(bookFromTable.authors, bookModel.authors);
      expect(bookFromTable.publisher, bookModel.publisher);
      expect(bookFromTable.description, bookModel.description);
      expect(bookFromTable.categories, bookModel.categories);
      expect(bookFromTable.pageCount, bookModel.pageCount);
      expect(bookFromTable.imageUrl, bookModel.imageUrl);
      expect(bookFromTable.buyLink, bookModel.buyLink);
      expect(bookFromTable.averageRating, bookModel.averageRating);
      expect(bookFromTable.ratingsCount, bookModel.ratingsCount);
      expect(bookFromTable.status, BookStatus.library);
    });

    test('test complete insert book with author and category.', () async {
      //test by inserting two other authors to prove the relationship with the book.
      bookModel.authors
          .addAll([AuthorModel(name: 'author2'), AuthorModel(name: 'author3')]);

      // inserts a book into the 'book' table and expects there to be a row added.
      final rowBook = await database.insert('book', bookModel.toMap());
      expect(rowBook, equals(1));

      // inserts authors into the 'author' table and expects their respective ids to be provided.
      final authorsIds = bookModel.authors
          .map((e) async => await database.insert('author', e.toMap()))
          .toList();

      expect(await authorsIds[0], equals(1));
      expect(await authorsIds[1], equals(2));
      expect(await authorsIds[2], equals(3));

      //insert the relationship between the book and the authors in the table and retrieve the respective id.
      final bookAuthorsIds = authorsIds
          .map((id) async => await database.insert('bookAuthors', {
                'bookId': bookModel.id,
                'authorId': await id,
              }))
          .toList();

      expect(await bookAuthorsIds[0], equals(1));
      expect(await bookAuthorsIds[1], equals(2));
      expect(await bookAuthorsIds[2], equals(3));

      //insert the category into the "category" table and expects the respective ID to be provided.
      final categoryId =
          await database.insert('category', bookModel.categories.first.toMap());
      expect(categoryId, equals(1));

      //insert the relationship between the book and the category into the table and retrieve the respective id.
      final bookCategoryId = await database.insert('bookCategories', {
        'bookId': bookModel.id,
        'categoryId': categoryId,
      });
      expect(bookCategoryId, equals(1));

      //query the ids of authors who have a relationship with the book.
      //Then retrieve the authors from the table and fill them into a list of AuthorModel.
      final booksAuthorRelationshipId = await database.query(
        'bookAuthors',
        where: 'bookId = ?',
        whereArgs: [bookModel.id],
      );

      expect(booksAuthorRelationshipId[0].values.last, 1);
      expect(booksAuthorRelationshipId[1].values.last, 2);
      expect(booksAuthorRelationshipId[2].values.last, 3);

      final authorIdsOnRelationship = booksAuthorRelationshipId
          .map((relationship) => relationship.values.last)
          .toList();

      expect(authorIdsOnRelationship[0], 1);
      expect(authorIdsOnRelationship[1], 2);
      expect(authorIdsOnRelationship[2], 3);

      List<AuthorModel> tableAuthors = [];

      for (var id in authorIdsOnRelationship) {
        final authorMap = await database.query(
          'author',
          where: 'id = ?',
          whereArgs: [id],
        );

        tableAuthors.add(AuthorModel.fromMap(authorMap.first));
      }

      expect(tableAuthors[0].name, equals('author'));
      expect(tableAuthors[1].name, equals('author2'));
      expect(tableAuthors[2].name, equals('author3'));

      //query the id of the category that has a relation to the book.
      //Then retrieve the category from the table and fill it into a CategoryModel.
      final booksCategoryRelationshipId = await database.query(
        'bookCategories',
        where: 'bookId = ?',
        whereArgs: [bookModel.id],
      );
      expect(booksCategoryRelationshipId[0].values.last, 1);

      final categoryIdOnRelationship = booksCategoryRelationshipId
          .map((relationship) => relationship.values.last)
          .last as int;

      expect(categoryIdOnRelationship, 1);

      final categoryMap = await database.query(
        'category',
        where: 'id = ?',
        whereArgs: [categoryIdOnRelationship],
      );

      final tableCategory = CategoryModel.fromMap(categoryMap.first);
      expect(tableCategory.name, equals('categories'));

      //finally, query the book from the already known id.
      // Fill it into a BookModel and add the authors and category with a copyWith.
      final bookMap = await database
          .query('book', where: 'id = ?', whereArgs: [bookModel.id]);
      var bookFromTable = BookModel.fromMap(bookMap.last);

      bookFromTable = bookFromTable
          .copyWith(authors: tableAuthors, categories: [tableCategory]);

      expect(bookFromTable.id, bookModel.id);
      expect(bookFromTable.title, bookModel.title);
      expect(
        bookFromTable.authors.first.name,
        bookModel.authors.first.name,
      );
      expect(bookFromTable.publisher, bookModel.publisher);
      expect(bookFromTable.description, bookModel.description);
      expect(
        bookFromTable.categories.first.name,
        bookModel.categories.first.name,
      );
      expect(bookFromTable.pageCount, bookModel.pageCount);
      expect(bookFromTable.imageUrl, bookModel.imageUrl);
      expect(bookFromTable.buyLink, bookModel.buyLink);
      expect(bookFromTable.averageRating, bookModel.averageRating);
      expect(bookFromTable.ratingsCount, bookModel.ratingsCount);
      expect(bookFromTable.status, BookStatus.library);
    });
  });
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
