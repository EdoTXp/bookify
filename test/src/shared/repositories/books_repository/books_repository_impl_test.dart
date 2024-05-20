import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
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

      when(() => localDatabase.getItemById(
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

    test('get book by name()', () async {
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

      when(() => localDatabase.researchBy(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [bookMap]);

      final bookModelByName = await bookRepository.getBooksByTitle(
          title: 'Memórias Póstumas De Brás Cubas');

      expect(bookModelByName[0].id, equals('1'));
      expect(bookModelByName[0].title, 'Memórias Póstumas De Brás Cubas');
      expect(
        bookModelByName[0].publisher,
        'FTD Editora',
      );
      expect(
        bookModelByName[0].description,
        'É narrada pelo defunto Brás Cubas...',
      );
      expect(bookModelByName[0].pageCount, 320);
      expect(bookModelByName[0].imageUrl, 'imageUrl');
      expect(bookModelByName[0].buyLink, 'buyLink');
      expect(bookModelByName[0].averageRating, 4.3);
      expect(bookModelByName[0].ratingsCount, 715);
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

    test('get book image', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer(
        (_) async => {'imageUrl': 'http:www//imageurl.com'},
      );

      final image = await bookRepository.getBookImageById(id: '1');

      expect(image, equals('http:www//imageurl.com'));
    });

    test('getStatus', () async {
      when(
        () => localDatabase.getColumnsById(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => {'status': 1});

      final bookStatus = await bookRepository.getBookStatus(id: 'bookId');

      expect(bookStatus, equals(BookStatus.library));
    });

    test('update book status', () async {
      when(() => localDatabase.update(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
            values: any(named: 'values'),
          )).thenAnswer(
        (_) async => 1,
      );

      final bookUpdated = await bookRepository.updateBookStatus(
          id: '1', status: BookStatus.reading);
      expect(bookUpdated, equals(1));
    });

    test('update book page Count', () async {
      when(() => localDatabase.update(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
            values: any(named: 'values'),
          )).thenAnswer(
        (_) async => 1,
      );

      final bookUpdated =
          await bookRepository.updateBookPageCount(id: '1', pageCount: 100);
      expect(bookUpdated, equals(1));
    });

    test('countBooks', () async {
      when(
        () => localDatabase.countItems(
          table: any(named: 'table'),
        ),
      ).thenAnswer(
        (_) async => 10,
      );

      final booksCount = await bookRepository.countBooks();

      expect(booksCount, equals(10));
    });
  });

  group('Test normal CRUD book with error ||', () {
    test('insert book -- LocalDatabaseException', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.insert(bookModel: bookModel),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('delete book -- LocalDatabaseException', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.deleteBookById(id: bookModel.id),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('verify book is already inserted -- LocalDatabaseException', () async {
      when(() => localDatabase.verifyItemIsAlreadyInserted(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValue: any(named: 'columnValue'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.verifyBookIsAlreadyInserted(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book by id -- TypeError', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': '1'});

      expect(
        () async => await bookRepository.getBookById(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('get book by id -- LocalDatabaseException', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.getBookById(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book by Title -- TypeError', () async {
      when(() => localDatabase.researchBy(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [{}]);

      expect(
          () async => await bookRepository.getBooksByTitle(
              title: 'Memórias Postumas de Bras Cubas'),
          throwsA((Exception e) =>
              e is LocalDatabaseException &&
              e.message ==
                  'Impossível encontrar os livros com esse título no database'));
    });

    test('get book by Title -- LocalDatabaseException', () async {
      when(() => localDatabase.researchBy(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
          () async => await bookRepository.getBooksByTitle(
              title: 'Memórias Postumas de Bras Cubas'),
          throwsA((Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database'));
    });

    test('get all books -- TypeError', () async {
      when(() => localDatabase.getAll(
            table: any(named: 'table'),
          )).thenAnswer((_) async => [
            {'id': '1'}
          ]);

      expect(
        () async => await bookRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('get all books -- LocalDatabaseException', () async {
      when(() => localDatabase.getAll(
            table: any(named: 'table'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book image -- TypeError', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {});

      expect(
        () async => await bookRepository.getBookImageById(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('get book image -- LocalDatabaseException', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await bookRepository.getBookImageById(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('getStatus -- typeError', () async {
      when(
        () => localDatabase.getColumnsById(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => {'status': null});

      expect(
        () async => await bookRepository.getBookStatus(id: 'bookId'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar o status do livro no database'),
      );
    });

    test('getStatus -- LocalDatabaseException', () async {
      when(
        () => localDatabase.getColumnsById(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenThrow(const LocalDatabaseException('error on database'));

      expect(
        () async => await bookRepository.getBookStatus(id: 'bookId'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'error on database'),
      );
    });

    test('update book status -- LocalDatabaseException', () async {
      when(() => localDatabase.update(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id'),
              values: any(named: 'values')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.updateBookStatus(
          id: '1',
          status: BookStatus.reading,
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('update book page Count -- assertion failed', () async {
      when(() => localDatabase.update(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id'),
              values: any(named: 'values')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.updateBookPageCount(
          id: '1',
          pageCount: 0,
        ),
        throwsA(
          (AssertionError e) =>
              e.message == 'pagesCount must be greater than 0',
        ),
      );
    });

    test('update book page Count -- LocalDatabaseException', () async {
      when(() => localDatabase.update(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id'),
              values: any(named: 'values')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.updateBookPageCount(
          id: '1',
          pageCount: 100,
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('countBooks -- LocalDatabaseException', () async {
      when(
        () => localDatabase.countItems(
          table: any(named: 'table'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookRepository.countBooks(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
