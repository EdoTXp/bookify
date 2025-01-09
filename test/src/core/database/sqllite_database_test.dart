import 'package:bookify/src/core/helpers/color_to_int/color_to_int_extension.dart';
import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// These tests are used to prove whether the table logic and SQL scripts work correctly.
void main() {
  late Database database;

  final booksModel = <BookModel>[
    BookModel(
      id: '1',
      title: 'title',
      authors: [AuthorModel(name: 'author')],
      publisher: 'publisher',
      description: 'description',
      categories: [CategoryModel(name: 'category')],
      pageCount: 320,
      imageUrl: 'imageUrl',
      buyLink: 'buyLink',
      averageRating: 3.4,
      ratingsCount: 120,
    ),
    BookModel(
      id: '2',
      title: 'title',
      authors: [AuthorModel(name: 'author')],
      publisher: 'publisher',
      description: 'description',
      categories: [CategoryModel(name: 'category')],
      pageCount: 80,
      imageUrl: 'imageUrl',
      buyLink: 'buyLink',
      averageRating: 3.4,
      ratingsCount: 120,
    ),
  ];

  setUp(() async {
    // Initialize FFI and open database
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);

    // Enable foreign_keys
    await database.execute('PRAGMA foreign_keys = ON');

    final batch = database.batch();

    // Execute all tables scripts
    batch.execute(DatabaseScripts().bookScript);
    batch.execute(DatabaseScripts().categoryScript);
    batch.execute(DatabaseScripts().authorScript);
    batch.execute(DatabaseScripts().bookAuthorsScript);
    batch.execute(DatabaseScripts().bookCategoriesScript);
    batch.execute(DatabaseScripts().bookReadingScript);
    batch.execute(DatabaseScripts().loanScript);
    batch.execute(DatabaseScripts().bookcaseScript);
    batch.execute(DatabaseScripts().bookOnCaseScript);

    await batch.commit();
  });

  tearDown(() async {
    await database.close();
  });

  group('test all SQL methods in all tables ||', () {
    test('book, author & category tables', () async {
      final bookTableName = DatabaseScripts().bookTableName;
      final authorTableName = DatabaseScripts().authorTableName;
      final categoryTableName = DatabaseScripts().categoryTableName;
      final bookAuthorsTableName = DatabaseScripts().bookAuthorsTableName;
      final bookCategoriesTableName = DatabaseScripts().bookCategoriesTableName;

      final authors = <AuthorModel>[
        ...booksModel[0].authors,
        AuthorModel(name: 'author2'),
        AuthorModel(name: 'author3'),
        AuthorModel(name: 'author4'),
      ];

      final categories = <CategoryModel>[
        ...booksModel[0].categories,
        CategoryModel(name: 'category2')
      ];

      // TEST insertion of book
      int bookRowsInserted = 0;
      for (var book in booksModel) {
        bookRowsInserted =
            await _insertOnDatabase(database, bookTableName, book.toMap());
      }
      expect(bookRowsInserted, equals(2));

      // TEST insertion of authors and retrive id
      for (var author in authors) {
        author.id =
            await _insertOnDatabase(database, authorTableName, author.toMap());
      }
      expect(authors[0].id, equals(1));
      expect(authors[1].id, equals(2));
      expect(authors[2].id, equals(3));
      expect(authors[3].id, equals(4));

      //TEST insertion of categories and retrive id
      for (var category in categories) {
        category.id = await _insertOnDatabase(
            database, categoryTableName, category.toMap());
      }
      expect(categories[0].id, equals(1));
      expect(categories[1].id, equals(2));

      // Insertion of relationship between books and authors
      await _insertOnDatabase(database, bookAuthorsTableName,
          {'bookId': booksModel[0].id, 'authorId': authors[0].id});
      await _insertOnDatabase(database, bookAuthorsTableName,
          {'bookId': booksModel[0].id, 'authorId': authors[1].id});
      await _insertOnDatabase(database, bookAuthorsTableName,
          {'bookId': booksModel[1].id, 'authorId': authors[0].id});
      await _insertOnDatabase(database, bookAuthorsTableName,
          {'bookId': booksModel[1].id, 'authorId': authors[2].id});
      await _insertOnDatabase(database, bookAuthorsTableName,
          {'bookId': booksModel[1].id, 'authorId': authors[3].id});

      final bookAuthorsList = await _queryOnDatabaseWhenId(
        database,
        bookAuthorsTableName,
        'bookId',
        [booksModel[1].id],
      );

      expect(bookAuthorsList[0]['bookId'], equals('2'));
      expect(bookAuthorsList[1]['bookId'], equals('2'));
      expect(bookAuthorsList[2]['bookId'], equals('2'));

      // Insertion of relationship between books and categories
      await _insertOnDatabase(database, bookCategoriesTableName,
          {'bookId': booksModel[0].id, 'categoryId': categories[0].id});
      await _insertOnDatabase(database, bookCategoriesTableName,
          {'bookId': booksModel[0].id, 'categoryId': categories[1].id});
      await _insertOnDatabase(database, bookCategoriesTableName,
          {'bookId': booksModel[1].id, 'categoryId': categories[1].id});

      final bookCategoriesList = await _queryOnDatabaseWhenId(
          database, bookCategoriesTableName, 'bookId', [booksModel[0].id]);
      expect(bookCategoriesList[0]['bookId'], equals('1'));
      expect(bookCategoriesList[1]['bookId'], equals('1'));

      // TEST update category with id 2
      await _updateRowWhenId(
        database,
        categoryTableName,
        'id',
        [categories[1].id],
        {'name': 'Horror'},
      );
      final newCategoryMap = await _queryOnDatabaseWhenId(
        database,
        categoryTableName,
        'id',
        [categories[1].id],
      );
      final newCategory = CategoryModel.fromMap(newCategoryMap.first);
      expect(newCategory.name, equals('Horror'));

      // TEST update author with id 2
      await _updateRowWhenId(
        database,
        authorTableName,
        'id',
        [authors[1].id],
        {'name': 'Carlos'},
      );
      final newAuthorMap = await _queryOnDatabaseWhenId(
        database,
        authorTableName,
        'id',
        [authors[1].id],
      );
      final newAuthor = AuthorModel.fromMap(newAuthorMap.first);
      expect(newAuthor.name, equals('Carlos'));

      //TEST Delete the book with id '2' and expect its relations to be deleted.
      final deleteBookRowAffected = await _deleteRowWhenId(
        database,
        bookTableName,
        'id',
        [booksModel[1].id],
      );
      expect(deleteBookRowAffected, equals(1));

      final bookAuthorsMap = await _queryOnDatabaseWhenId(
        database,
        bookAuthorsTableName,
        'bookId',
        [booksModel[1].id],
      );
      expect(bookAuthorsMap, equals(isEmpty));

      final bookCategoriesMap = await _queryOnDatabaseWhenId(
        database,
        bookCategoriesTableName,
        'bookId',
        [booksModel[1].id],
      );
      expect(bookCategoriesMap, equals(isEmpty));

      //TEST if it has not deleted the author and category that they referenced before.
      final authorMap = await _queryOnDatabaseWhenId(
        database,
        authorTableName,
        'id',
        [authors[0].id],
      );
      expect(authorMap, isNotEmpty);

      final categoryMap = await _queryOnDatabaseWhenId(
        database,
        categoryTableName,
        'id',
        [categories[1].id],
      );
      expect(categoryMap, isNotEmpty);
    });

    test('book & reading tables', () async {
      final bookTableName = DatabaseScripts().bookTableName;
      final readingTableName = DatabaseScripts().bookReadingTableName;

      // TEST insertion of book
      int bookRowsInserted = 0;
      for (var book in booksModel) {
        bookRowsInserted =
            await _insertOnDatabase(database, bookTableName, book.toMap());
      }
      expect(bookRowsInserted, equals(2));

      //TEST insertion of reading
      await _insertOnDatabase(database, readingTableName, {
        'pagesReaded': 10,
        'lastReadingDate': DateTime(2023, 02, 17).millisecondsSinceEpoch,
        'bookId': booksModel[0].id,
      });

      // UPDATE book with status "reading" = 2
      await _updateRowWhenId(database, bookTableName, 'id', [
        booksModel[0].id
      ], {
        'status': BookStatus.reading.statusNumber,
      });

      await _insertOnDatabase(database, readingTableName, {
        'pagesReaded': 75,
        'lastReadingDate': DateTime(2023, 05, 10).millisecondsSinceEpoch,
        'bookId': booksModel[1].id,
      });

      // UPDATE book with status "reading" = 2
      await _updateRowWhenId(database, bookTableName, 'id', [
        booksModel[1].id
      ], {
        'status': BookStatus.reading.statusNumber,
      });

      // VERiFY that there are two books with the status "reading" = 2
      final booksUpdated = await database
          .query(bookTableName, where: 'status = ?', whereArgs: ['2']);

      expect(booksUpdated.length, equals(2));

      final readingsListMap = await database.query(readingTableName,
          orderBy: 'lastReadingDate DESC');
      expect(readingsListMap[0]['id'], equals(2));
      expect(readingsListMap[1]['id'], equals(1));

      //TEST UPDATE reading with id 2
      final readingRowChanges = await _updateRowWhenId(
          database, readingTableName, 'id', [1], {'pagesReaded': 55});
      expect(readingRowChanges, equals(1));

      final newReadingMap = await _queryOnDatabaseWhenId(
        database,
        readingTableName,
        'id',
        [1],
      );
      expect(newReadingMap.last['pagesReaded'], equals(55));

      //TEST DELETE book with id 2
      final bookRowChanges = await _deleteRowWhenId(
        database,
        bookTableName,
        'id',
        [booksModel[1].id],
      );
      expect(bookRowChanges, equals(1));

      final readingRelationshipChanges = await _queryOnDatabaseWhenId(
        database,
        readingTableName,
        'bookId',
        [booksModel[1].id],
      );
      expect(readingRelationshipChanges, isEmpty);
    });

    test('book, loan & people tables', () async {
      final bookTableName = DatabaseScripts().bookTableName;
      final loanTableName = DatabaseScripts().loanTableName;

      // TEST insertion of book
      final bookRowInserted = await _insertOnDatabase(
          database, bookTableName, booksModel[0].toMap());

      expect(bookRowInserted, equals(1));

      // TEST insertion of loan
      final loanMap = {
        'observation': 'Amigo da Jú',
        'loanDate': DateTime(2023, 05, 23).millisecondsSinceEpoch,
        'devolutionDate': DateTime(2023, 06, 10).millisecondsSinceEpoch,
        'idContact': 'idContact',
        'bookId': booksModel[0].id,
      };

      final loanId = await _insertOnDatabase(database, loanTableName, loanMap);
      expect(loanId, equals(1));

      //TEST UPDATE loan
      final updateLoanRow =
          await _updateRowWhenId(database, loanTableName, 'id', [
        loanId
      ], {
        'devolutionDate': DateTime(2023, 06, 20).millisecondsSinceEpoch,
      });
      expect(updateLoanRow, equals(1));

      final newLoanMap =
          await _queryOnDatabaseWhenId(database, loanTableName, 'id', [loanId]);
      expect(newLoanMap.first['id'], equals(1));
      expect(
        DateTime.fromMillisecondsSinceEpoch(
            newLoanMap.first['loanDate'] as int),
        equals(DateTime(2023, 05, 23)),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(
            newLoanMap.first['devolutionDate'] as int),
        equals(DateTime(2023, 06, 20)),
      );
      expect(newLoanMap.first['idContact'], equals('idContact'));
      expect(newLoanMap.first['bookId'], equals(booksModel[0].id));

      //TEST DELETE book and expect its relations to be deleted.
      final bookDeletedRow = await _deleteRowWhenId(
          database, bookTableName, 'id', [booksModel[0].id]);
      expect(bookDeletedRow, equals(1));

      final deletedLoanRelationship =
          await _queryOnDatabaseWhenId(database, loanTableName, 'id', [loanId]);
      expect(deletedLoanRelationship, isEmpty);
    });

    test('book & bookcase tables', () async {
      final bookTableName = DatabaseScripts().bookTableName;
      final bookcaseTableName = DatabaseScripts().bookcaseTableName;
      final bookOnCaseTableName = DatabaseScripts().bookOnCaseTableName;

      // TEST insertion of book
      int bookRowsInserted = 0;
      for (var book in booksModel) {
        bookRowsInserted =
            await _insertOnDatabase(database, bookTableName, book.toMap());
      }
      expect(bookRowsInserted, equals(2));

      // TEST insertion of bookcase
      final bookcaseMap = {
        'name': 'Fantasia',
        'description': 'Meus livros de fantasia',
        'color': Colors.pink.colorToInt(),
      };
      final bookcaseId = await _insertOnDatabase(
        database,
        bookcaseTableName,
        bookcaseMap,
      );
      expect(bookcaseId, equals(1));

      // TEST insertion of bookcase and book relationship
      await _insertOnDatabase(database, bookOnCaseTableName, {
        'bookId': booksModel[0].id,
        'bookcaseId': 1,
      });
      await _insertOnDatabase(database, bookOnCaseTableName, {
        'bookId': booksModel[1].id,
        'bookcaseId': 1,
      });

      final bookOnCaseList = await _queryOnDatabaseWhenId(
        database,
        bookOnCaseTableName,
        'bookcaseId',
        [1],
      );
      expect(bookOnCaseList[0]['bookId'], equals('1'));
      expect(bookOnCaseList[1]['bookId'], equals('2'));

      //TEST UPDATE bookcase
      final bookcaseRowChanges = await _updateRowWhenId(
        database,
        bookcaseTableName,
        'id',
        [1],
        {
          'name': 'Tecnologia',
          'description': 'Meus livros de tecnologia',
        },
      );
      expect(bookcaseRowChanges, equals(1));

      final newBookcase = await _queryOnDatabaseWhenId(
        database,
        bookcaseTableName,
        'id',
        [1],
      );
      expect(newBookcase.last['name'], equals('Tecnologia'));
      expect(
          newBookcase.last['description'], equals('Meus livros de tecnologia'));

      //TEST DELETE bookcase and expect its relations to be deleted.
      final bookcaseRowDeleted = await _deleteRowWhenId(
        database,
        bookcaseTableName,
        'id',
        [1],
      );
      expect(bookcaseRowDeleted, equals(1));

      final bookOnCaseIsEmpty = await _queryOnDatabaseWhenId(
        database,
        bookcaseTableName,
        'id',
        [1],
      );
      expect(bookOnCaseIsEmpty, isEmpty);

      //TEST if it has not deleted the book that they referenced before.
      final bookIsNotEmpty = await _queryOnDatabaseWhenId(
        database,
        bookTableName,
        'id',
        [booksModel[0].id],
      );
      expect(bookIsNotEmpty, isNotEmpty);
    });
  });
}

Future<int> _insertOnDatabase(
    Database db, String table, Map<String, Object?> values) async {
  return await db.insert(table, values);
}

Future<List<Map<String, Object?>>> _queryOnDatabaseWhenId(
  Database db,
  String table,
  String idName,
  List<Object?> id,
) async {
  return await db.query(
    table,
    where: '$idName = ?',
    whereArgs: id,
  );
}

Future<int> _updateRowWhenId(
  Database db,
  String table,
  String idName,
  List<Object?> id,
  Map<String, Object?> values,
) async {
  return await db.update(table, values, where: '$idName = ?', whereArgs: id);
}

Future<int> _deleteRowWhenId(
  Database db,
  String table,
  String idName,
  List<Object?> id,
) async {
  return await db.delete(table, where: '$idName = ?', whereArgs: id);
}
