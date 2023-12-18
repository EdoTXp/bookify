import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/models/books_model_mock.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final bookModel = booksModelMock.first;
  final localDatabase = LocalDatabaseMock();
  final bookRepository = BooksRepositoryImpl(localDatabase);

  group('Test normal CRUD book without error ||', () {
    test('insert book', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final bookInsertedRow = await bookRepository.insert(bookModel: bookModel);
      expect(bookInsertedRow, equals(1));
    });

    test('delete book', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => 1);

      final bookRemovedRow =
          await bookRepository.deleteBookById(id: bookModel.id);
      expect(bookRemovedRow, equals(1));
    });

    test('verify book is already inserted', () async {
      when(() => localDatabase.verifyItemIsAlreadyInserted(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValue: any(named: 'columnValue'),
          )).thenAnswer((_) async => true);

      final bookIsInserted =
          await bookRepository.verifyBookIsAlreadyInserted(id: bookModel.id);
      expect(bookIsInserted, equals(true));
    });

    test('get book by id', () async {
      final bookMap = {
        'id': '1',
        'title': 'Memórias Póstumas De Brás Cubas',
        'publisher': 'FTD Editora',
        'description': 'É narrada pelo defunto Brás Cubas...',
        'pageCount': 320,
        'imageUrl': 'imageUrl',
        'buyLink': 'buyLink',
        'averageRating': 4.3,
        'ratingsCount': 715,
        'status': 1,
      };

      when(() => localDatabase.getById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => bookMap);

      final bookModelFromMap = await bookRepository.getBookById(id: '1');

      expect(bookModelFromMap.id, equals('1'));
      expect(bookModelFromMap.title, equals('Memórias Póstumas De Brás Cubas'));
      expect(bookModelFromMap.publisher, equals('FTD Editora'));
      expect(bookModelFromMap.description,
          equals('É narrada pelo defunto Brás Cubas...'));
      expect(bookModelFromMap.pageCount, equals(320));
      expect(bookModelFromMap.imageUrl, equals('imageUrl'));
      expect(bookModelFromMap.buyLink, equals('buyLink'));
      expect(bookModelFromMap.averageRating, equals(4.3));
      expect(bookModelFromMap.ratingsCount, equals(715));
      expect(bookModelFromMap.status, equals(BookStatus.library));
      expect(bookModelFromMap.authors, isEmpty);
      expect(bookModelFromMap.categories, isEmpty);
    });

    test('get all books', () async {
      when(() => localDatabase.getAll(
            table: any(named: 'table'),
          )).thenAnswer(
        (_) async => booksModelMock.map((book) => book.toMap()).toList(),
      );

      final books = await bookRepository.getAll();

      expect(books.length, equals(2));
      expect(books[0].id, equals('1'));
      expect(books[0].pageCount, equals(320));
      expect(books[0].ratingsCount, equals(4));
      expect(books[0].averageRating, equals(5.2));
      expect(books[1].id, equals('2'));
      expect(books[1].pageCount, equals(157));
      expect(books[1].ratingsCount, equals(0));
      expect(books[1].averageRating, equals(0));
    });
  });
}
