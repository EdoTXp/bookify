import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/repositories/book_on_case_repository/book_on_case_repository.dart';
import 'package:bookify/src/core/repositories/bookcase_repository/bookcase_repository.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service_impl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseRepositoryMock extends Mock implements BookcaseRepository {}

class BookOnCaseRepositoryMock extends Mock implements BookOnCaseRepository {}

void main() {
  final bookcaseRepository = BookcaseRepositoryMock();
  final bookOnCaseRepository = BookOnCaseRepositoryMock();

  final bookcaseService = BookcaseServiceImpl(
    bookcaseRepository: bookcaseRepository,
    bookOnCaseRepository: bookOnCaseRepository,
  );

  final bookcases = [
    const BookcaseModel(
      name: 'name',
      description: 'description',
      color: Colors.pink,
    ),
    const BookcaseModel(
      name: 'name2',
      description: 'description2',
      color: Colors.red,
    ),
  ];

  group('test normal CRUD of complete book without error ||', () {
    test('getAllBookcases()', () async {
      when(() => bookcaseRepository.getAll())
          .thenAnswer((_) async => bookcases);

      final bookcasesModel = await bookcaseService.getAllBookcases();

      expect(bookcasesModel[0].name, equals('name'));
      expect(bookcasesModel[0].description, equals('description'));
      expect(bookcasesModel[0].color, equals(Colors.pink));
      expect(bookcasesModel[1].name, equals('name2'));
      expect(bookcasesModel[1].description, equals('description2'));
      expect(bookcasesModel[1].color, equals(Colors.red));
    });

    test('getBookcasesByName()', () async {
      when(() =>
              bookcaseRepository.getBookcasesByName(name: any(named: 'name')))
          .thenAnswer((_) async => [bookcases[0]]);

      final bookcaseModel =
          await bookcaseService.getBookcasesByName(name: 'name');

      expect(bookcaseModel[0].name, equals('name'));
      expect(bookcaseModel[0].description, equals('description'));
      expect(bookcaseModel[0].color, equals(Colors.pink));
    });

    test('getAllBookcaseRelationships()', () async {
      when(() => bookOnCaseRepository
              .getBooksOnCaseRelationship(bookcaseId: any(named: 'bookcaseId')))
          .thenAnswer((_) async => [
                {'bookcaseId': 1, 'bookId': '1'},
                {'bookcaseId': 1, 'bookId': '2'},
                {'bookcaseId': 1, 'bookId': '5'},
                {'bookcaseId': 1, 'bookId': '6'},
              ]);

      final bookcasesRelationships =
          await bookcaseService.getAllBookcaseRelationships(bookcaseId: 1);

      expect(bookcasesRelationships[0]['bookcaseId'], equals(1));
      expect(bookcasesRelationships[0]['bookId'], equals('1'));
      expect(bookcasesRelationships[1]['bookcaseId'], equals(1));
      expect(bookcasesRelationships[1]['bookId'], equals('2'));
      expect(bookcasesRelationships[2]['bookcaseId'], equals(1));
      expect(bookcasesRelationships[2]['bookId'], equals('5'));
      expect(bookcasesRelationships[3]['bookcaseId'], equals(1));
      expect(bookcasesRelationships[3]['bookId'], equals('6'));
    });

    test('getBookIdForImagePreview()', () async {
      when(() => bookOnCaseRepository.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')))
          .thenAnswer((_) async => 'bookId');

      final bookId =
          await bookcaseService.getBookIdForImagePreview(bookcaseId: 1);
      expect(bookId, equals('bookId'));
    });

    test('getBookIdForImagePreview() -- with null', () async {
      when(() => bookOnCaseRepository.getBookIdForImagePreview(
          bookcaseId: any(named: 'bookcaseId'))).thenAnswer((_) async => null);

      final bookId =
          await bookcaseService.getBookIdForImagePreview(bookcaseId: 1);
      expect(bookId, isNull);
    });

    test('getBookcaseById()', () async {
      when(() =>
              bookcaseRepository.getById(bookcaseId: any(named: 'bookcaseId')))
          .thenAnswer((_) async => bookcases[0]);

      final bookcaseModel =
          await bookcaseService.getBookcaseById(bookcaseId: 1);

      expect(bookcaseModel.name, equals('name'));
      expect(bookcaseModel.description, equals('description'));
      expect(bookcaseModel.color, equals(Colors.pink));
    });

    test('insertBookcase()', () async {
      when(
        () => bookcaseRepository.insert(bookcaseModel: bookcases[0]),
      ).thenAnswer((_) async => 1);

      final newBookcaseId =
          await bookcaseService.insertBookcase(bookcaseModel: bookcases[0]);

      expect(newBookcaseId, equals(1));
    });

    test('insertBookcaseRelationship()', () async {
      when(
        () => bookOnCaseRepository.insert(
            bookcaseId: any(named: 'bookcaseId'), bookId: any(named: 'bookId')),
      ).thenAnswer((_) async => 1);

      final newRelationshipRow = await bookcaseService
          .insertBookcaseRelationship(bookcaseId: 1, bookId: '1');

      expect(newRelationshipRow, equals(1));
    });

    test('countBookcases()', () async {
      when(
        () => bookcaseRepository.countBookcases(),
      ).thenAnswer(
        (_) async => 10,
      );

      final bookcasesCount = await bookcaseService.countBookcases();
      expect(bookcasesCount, equals(10));
    });

    test('countBookcasesByBook()', () async {
      when(
        () => bookOnCaseRepository.countBookcasesByBook(
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenAnswer((_) async => 2);

      final bookcasesCount = await bookcaseService.countBookcasesByBook(
        bookId: '1',
      );

      expect(bookcasesCount, equals(2));
    });

    test('updateBookcase()', () async {
      when(
        () => bookcaseRepository.update(bookcaseModel: bookcases[0]),
      ).thenAnswer((_) async => 1);

      final bookcaseRowUpdated =
          await bookcaseService.updateBookcase(bookcaseModel: bookcases[0]);

      expect(bookcaseRowUpdated, equals(1));
    });

    test('deleteBookcase()', () async {
      when(
        () => bookcaseRepository.delete(bookcaseId: any(named: 'bookcaseId')),
      ).thenAnswer((_) async => 1);

      final bookcaseRowDeleted =
          await bookcaseService.deleteBookcase(bookcaseId: 1);

      expect(bookcaseRowDeleted, equals(1));
    });

    test('deleteBookcaseRelationship()', () async {
      when(
        () => bookOnCaseRepository.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer((_) async => 1);

      final bookcaseRowDeleted = await bookcaseService
          .deleteBookcaseRelationship(bookcaseId: 1, bookId: '1');

      expect(bookcaseRowDeleted, equals(1));
    });
  });

  group('test normal CRUD of complete book with error ||', () {
    test('getAllBookcases()', () async {
      when(() => bookcaseRepository.getAll())
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.getAllBookcases(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getBookcasesByName()', () async {
      when(() =>
              bookcaseRepository.getBookcasesByName(name: any(named: 'name')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.getBookcasesByName(name: 'name'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getAllBookcaseRelationships()', () async {
      when(() => bookOnCaseRepository.getBooksOnCaseRelationship(
              bookcaseId: any(named: 'bookcaseId')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookcaseService.getAllBookcaseRelationships(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getBookIdForImagePreview()', () async {
      when(() => bookOnCaseRepository.getBookIdForImagePreview(
              bookcaseId: any(named: 'bookcaseId')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookcaseService.getBookIdForImagePreview(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getBookcaseById()', () async {
      when(() =>
              bookcaseRepository.getById(bookcaseId: any(named: 'bookcaseId')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.getBookcaseById(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('insertBookcase()', () async {
      when(
        () => bookcaseRepository.insert(bookcaseModel: bookcases[0]),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookcaseService.insertBookcase(bookcaseModel: bookcases[0]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('insertBookcaseRelationship()', () async {
      when(
        () => bookOnCaseRepository.insert(
            bookcaseId: any(named: 'bookcaseId'), bookId: any(named: 'bookId')),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.insertBookcaseRelationship(
            bookcaseId: 1, bookId: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('countBookcases()', () async {
      when(
        () => bookcaseRepository.countBookcases(),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.countBookcases(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('countBookcasesByBook()', () async {
      when(
        () => bookOnCaseRepository.countBookcasesByBook(
          bookId: any(
            named: 'bookId',
          ),
        ),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.countBookcasesByBook(
          bookId: '1',
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('updateBookcase()', () async {
      when(
        () => bookcaseRepository.update(bookcaseModel: bookcases[0]),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookcaseService.updateBookcase(bookcaseModel: bookcases[0]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('deleteBookcase()', () async {
      when(
        () => bookcaseRepository.delete(bookcaseId: any(named: 'bookcaseId')),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.deleteBookcase(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('deleteBookcaseRelationship()', () async {
      when(
        () => bookOnCaseRepository.deleteBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await bookcaseService.deleteBookcaseRelationship(
            bookcaseId: 1, bookId: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
