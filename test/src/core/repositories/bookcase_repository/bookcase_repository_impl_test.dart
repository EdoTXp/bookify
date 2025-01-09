import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/helpers/color_to_int/color_to_int_extension.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/repositories/bookcase_repository/bookcase_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final bookcasesMap = [
    {
      'id': 1,
      'name': 'Fantasia',
      'description': 'Meus Livros de Fantasia',
      'color': Colors.pink.colorToInt(),
    },
    {
      'id': 2,
      'name': 'Terror',
      'description': 'Meus Livros de Terror',
      'color': Colors.black.colorToInt(),
    },
  ];

  const bookcaseModel = BookcaseModel(
    name: 'Livros 2024',
    description: 'Meus livros de 2024',
    color: Colors.red,
  );

  final localDatabase = LocalDatabaseMock();
  final bookcaseRepository = BookcaseRepositoryImpl(localDatabase);

  group('Test normal CRUD bookcase without error ||', () {
    test('getAll()', () async {
      when(() => localDatabase.getAll(table: any(named: 'table')))
          .thenAnswer((_) async => bookcasesMap);

      final bookcasesModel = await bookcaseRepository.getAll();

      expect(bookcasesModel[0].id, equals(1));
      expect(bookcasesModel[0].name, 'Fantasia');
      expect(bookcasesModel[0].description, 'Meus Livros de Fantasia');
      expect(
        bookcasesModel[0].color,
        Color(
          Colors.pink.colorToInt(),
        ),
      );

      expect(bookcasesModel[1].id, equals(2));
      expect(bookcasesModel[1].name, 'Terror');
      expect(bookcasesModel[1].description, 'Meus Livros de Terror');
      expect(
        bookcasesModel[1].color,
        Color(
          Colors.black.colorToInt(),
        ),
      );
    });

    test('get by name()', () async {
      when(() => localDatabase.researchBy(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [bookcasesMap[0]]);

      final bookcaseModelByName =
          await bookcaseRepository.getBookcasesByName(name: 'Fantasia');

      expect(bookcaseModelByName[0].id, equals(1));
      expect(bookcaseModelByName[0].name, 'Fantasia');
      expect(bookcaseModelByName[0].description, 'Meus Livros de Fantasia');
      expect(
        bookcaseModelByName[0].color,
        Color(
          Colors.pink.colorToInt(),
        ),
      );
    });

    test('getById()', () async {
      when(() => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => bookcasesMap[0]);

      final bookcasesModel = await bookcaseRepository.getById(bookcaseId: 1);

      expect(bookcasesModel.id, equals(1));
      expect(bookcasesModel.name, 'Fantasia');
      expect(bookcasesModel.description, 'Meus Livros de Fantasia');
      expect(
        bookcasesModel.color,
        Color(
          Colors.pink.colorToInt(),
        ),
      );
    });

    test('countBookcases()', () async {
      when(
        () => localDatabase.countItems(
          table: any(named: 'table'),
        ),
      ).thenAnswer(
        (_) async => 10,
      );

      final bookcasesCount = await bookcaseRepository.countBookcases();

      expect(bookcasesCount, equals(10));
    });

    test('insert()', () async {
      when(() => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'))).thenAnswer((_) async => 3);

      final bookcaseInsertedId =
          await bookcaseRepository.insert(bookcaseModel: bookcaseModel);

      expect(bookcaseInsertedId, equals(3));
    });

    test('update()', () async {
      when(() => localDatabase.update(
          table: any(named: 'table'),
          values: any(named: 'values'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => 1);

      final bookcaseUpdatedRow = await bookcaseRepository.update(
          bookcaseModel: bookcaseModel.copyWith(color: Colors.blue));

      expect(bookcaseUpdatedRow, equals(1));
    });
    test('delete()', () async {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      final bookcaseDeletedRow = await bookcaseRepository.delete(bookcaseId: 1);

      expect(bookcaseDeletedRow, equals(1));
    });
  });

  group('Test normal CRUD bookcase with error ||', () {
    test('getAll() -- LocalDatabaseException', () async {
      when(() => localDatabase.getAll(table: any(named: 'table')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
          () async => await bookcaseRepository.getAll(),
          throwsA((Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database'));
    });

    test('getAll() -- TypeError', () async {
      when(() => localDatabase.getAll(table: any(named: 'table')))
          .thenAnswer((_) async => [
                {'id': 1}
              ]);

      expect(
        () async => await bookcaseRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar as estantes no database'),
      );
    });

    test('get by name() -- LocalDatabaseException', () async {
      when(() => localDatabase.researchBy(
              table: any(named: 'table'),
              column: any(named: 'column'),
              columnValues: any(named: 'columnValues')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
          () async =>
              await bookcaseRepository.getBookcasesByName(name: 'Fantasia'),
          throwsA((Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database'));
    });
  });

  test('get by name() -- TypeError', () async {
    when(() => localDatabase.researchBy(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues')))
        .thenAnswer((_) async => [{}]);

    expect(
        () async =>
            await bookcaseRepository.getBookcasesByName(name: 'Fantasia'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar as estantes no database'));
  });

  test('getById() -- LocalDatabaseException', () async {
    when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id')))
        .thenThrow(const LocalDatabaseException('Error on database'));

    expect(
        () async => await bookcaseRepository.getById(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'));
  });

  test('getById() -- TypeError', () async {
    when(() => localDatabase.getItemById(
        table: any(named: 'table'),
        idColumn: any(named: 'idColumn'),
        id: any(named: 'id'))).thenAnswer((_) async => {'id': 1});

    expect(
        () async => await bookcaseRepository.getById(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar a estante no database'));
  });

  test('countBookcases() -- LocalDatabaseException', () async {
    when(
      () => localDatabase.countItems(
        table: any(named: 'table'),
      ),
    ).thenThrow(const LocalDatabaseException('Error on database'));

    expect(
      () async => await bookcaseRepository.countBookcases(),
      throwsA((Exception e) =>
          e is LocalDatabaseException && e.message == 'Error on database'),
    );
  });

  test('insert() -- LocalDatabaseException', () async {
    when(() => localDatabase.insert(
            table: any(named: 'table'), values: any(named: 'values')))
        .thenThrow(const LocalDatabaseException('Error on database'));

    expect(
        () async =>
            await bookcaseRepository.insert(bookcaseModel: bookcaseModel),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'));
  });

  test('update() -- LocalDatabaseException', () async {
    when(() => localDatabase.update(
            table: any(named: 'table'),
            values: any(named: 'values'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id')))
        .thenThrow(const LocalDatabaseException('Error on database'));

    expect(
        () async => await bookcaseRepository.update(
            bookcaseModel: bookcaseModel.copyWith(color: Colors.blue)),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'));
  });

  test('delete() -- LocalDatabaseException', () async {
    when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id')))
        .thenThrow(const LocalDatabaseException('Error on database'));

    expect(
        () async => await bookcaseRepository.delete(bookcaseId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'));
  });
}
