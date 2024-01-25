import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/repositories/book_on_case_repository/book_on_case_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final bookOnCaseRepository = BookOnCaseRepositoryImpl(localDatabase);

  group('Test normal CRUD of bookcase/book without error ||', () {
    test('get bookcase/book relationships', () async {
      when(() => localDatabase.getItemsByColumn(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'))).thenAnswer(
        (_) async => [
          {'bookId': '1', 'bookcaseId': 1},
          {'bookId': '2', 'bookcaseId': 1},
        ],
      );

      final bookOnCaseRelationship =
          await bookOnCaseRepository.getBooksOnCaseRelationship(bookcaseId: 1);

      expect(bookOnCaseRelationship[0]['bookId'], equals('1'));
      expect(bookOnCaseRelationship[0]['bookcaseId'], equals(1));
      expect(bookOnCaseRelationship[1]['bookId'], equals('2'));
      expect(bookOnCaseRelationship[1]['bookcaseId'], equals(1));
    });

    test('getBookIdForImagePreview when bookId is null', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {});

      final bookId =
          await bookOnCaseRepository.getBookIdForImagePreview(bookcaseId: 3);
      expect(bookId, equals(null));
    });

    test('getBookIdForImagePreview', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'bookId': '1'});

      final bookId =
          await bookOnCaseRepository.getBookIdForImagePreview(bookcaseId: 3);
      expect(bookId, equals('1'));
    });

    test('insert relationship', () async {
      when(
        () => localDatabase.insert(
            table: any(named: 'table'), values: any(named: 'values')),
      ).thenAnswer((invocation) async => 1);

      final relationshipRowInserted =
          await bookOnCaseRepository.insert(bookcaseId: 1, bookId: '1');
      expect(relationshipRowInserted, equals(1));
    });

    test('delete relationship', () async {
      when(
        () => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id')),
      ).thenAnswer((invocation) async => 1);

      final relationshipRowDeleted =
          await bookOnCaseRepository.delete(bookcaseId: 1);
      expect(relationshipRowDeleted, equals(1));
    });
  });

  group('Test normal CRUD of bookcase/book with error ||', () {
    test('get bookcase/book relationships -- LocalDatabaseException', () async {
      when(() => localDatabase.getItemsByColumn(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async => await bookOnCaseRepository.getBooksOnCaseRelationship(
            bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getBookIdForImagePreview -- LocalDatabaseException', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookOnCaseRepository.getBookIdForImagePreview(bookcaseId: 3),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getBookIdForImagePreview -- TypeError', () async {
      when(() => localDatabase.getColumnsById(
            table: any(named: 'table'),
            columns: any(named: 'columns'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'bookId': 1});

      expect(
        () async =>
            await bookOnCaseRepository.getBookIdForImagePreview(bookcaseId: 3),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('insert relationship', () async {
      when(
        () => localDatabase.insert(
            table: any(named: 'table'), values: any(named: 'values')),
      ).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookOnCaseRepository.insert(bookcaseId: 1, bookId: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('delete relationship', () async {
      when(
        () => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id')),
      ).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async => await bookOnCaseRepository.delete(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
