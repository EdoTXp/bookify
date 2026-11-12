import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/data/database/local_database.dart';
import 'package:bookify/src/data/repositories/bookcase_repository/bookcase_repository_impl.dart';
import 'package:bookify/src/domain/models/bookcase_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  const databaseException = LocalDatabaseException(
    LocalDatabaseErrorCode.unknown,
    descriptionMessage: 'Error on database',
  );

  final bookcasesMap = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Fantasia',
      'description': 'Meus Livros de Fantasia',
      'color': Colors.pink.toARGB32(),
    },
    {
      'id': 2,
      'name': 'Terror',
      'description': 'Meus Livros de Terror',
      'color': Colors.black.toARGB32(),
    },
  ];

  final bookcaseModel = BookcaseModel(
    name: 'Livros 2024',
    description: 'Meus livros de 2024',
    colorValue: Colors.red.toARGB32(),
  );

  late LocalDatabaseMock localDatabase;
  late BookcaseRepositoryImpl bookcaseRepository;

  Matcher throwsDatabaseException() => throwsA(
    isA<LocalDatabaseException>()
        .having((e) => e.code, 'code', LocalDatabaseErrorCode.unknown)
        .having(
          (e) => e.descriptionMessage,
          'descriptionMessage',
          'Error on database',
        ),
  );

  Matcher throwsConversionFailed() => throwsA(
    isA<LocalDatabaseException>().having(
      (e) => e.code,
      'code',
      LocalDatabaseErrorCode.conversionFailed,
    ),
  );

  setUp(() {
    localDatabase = LocalDatabaseMock();
    bookcaseRepository = BookcaseRepositoryImpl(localDatabase);
  });

  group('BookcaseRepositoryImpl success ||', () {
    test('getAll()', () async {
      when(
        () => localDatabase.getAll(table: any(named: 'table')),
      ).thenAnswer((_) async => bookcasesMap);

      final bookcases = await bookcaseRepository.getAll();

      expect(bookcases, hasLength(2));
      expect(bookcases[0].id, 1);
      expect(bookcases[0].name, 'Fantasia');
      expect(bookcases[0].description, 'Meus Livros de Fantasia');
      expect(bookcases[0].colorValue, Colors.pink.toARGB32());
      expect(bookcases[1].id, 2);
      expect(bookcases[1].name, 'Terror');
      expect(bookcases[1].description, 'Meus Livros de Terror');
      expect(bookcases[1].colorValue, Colors.black.toARGB32());
    });

    test('getBookcasesByName()', () async {
      when(
        () => localDatabase.researchBy(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenAnswer((_) async => [bookcasesMap[0]]);

      final bookcases = await bookcaseRepository.getBookcasesByName(
        name: 'Fantasia',
      );

      expect(bookcases[0].id, 1);
      expect(bookcases[0].name, 'Fantasia');
      expect(bookcases[0].description, 'Meus Livros de Fantasia');
      expect(bookcases[0].colorValue, Colors.pink.toARGB32());
    });

    test('getById()', () async {
      when(
        () => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => bookcasesMap[0]);

      final bookcase = await bookcaseRepository.getById(bookcaseId: 1);

      expect(bookcase.id, 1);
      expect(bookcase.name, 'Fantasia');
      expect(bookcase.description, 'Meus Livros de Fantasia');
      expect(bookcase.colorValue, Colors.pink.toARGB32());
    });

    test('countBookcases()', () async {
      when(
        () => localDatabase.countItems(table: any(named: 'table')),
      ).thenAnswer((_) async => 10);

      expect(await bookcaseRepository.countBookcases(), 10);
    });

    test('insert() persists the color as an ARGB int', () async {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => 3);

      final bookcaseInsertedId = await bookcaseRepository.insert(
        bookcaseModel: bookcaseModel,
      );

      expect(bookcaseInsertedId, 3);
      verify(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: bookcaseModel.toMap(),
        ),
      ).called(1);
      expect(bookcaseModel.toMap()['color'], Colors.red.toARGB32());
    });

    test('update() persists the new color as an ARGB int', () async {
      final updatedModel = bookcaseModel.copyWith(
        colorValue: Colors.blue.toARGB32(),
      );
      when(
        () => localDatabase.update(
          table: any(named: 'table'),
          values: any(named: 'values'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      final bookcaseUpdatedRow = await bookcaseRepository.update(
        bookcaseModel: updatedModel,
      );

      expect(bookcaseUpdatedRow, 1);
      verify(
        () => localDatabase.update(
          table: any(named: 'table'),
          values: updatedModel.toMap(),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).called(1);
      expect(updatedModel.toMap()['color'], Colors.blue.toARGB32());
    });

    test('delete()', () async {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      expect(await bookcaseRepository.delete(bookcaseId: 1), 1);
    });
  });

  group('BookcaseRepositoryImpl errors ||', () {
    test('getAll() -- LocalDatabaseException', () {
      when(
        () => localDatabase.getAll(table: any(named: 'table')),
      ).thenThrow(databaseException);

      expect(() => bookcaseRepository.getAll(), throwsDatabaseException());
    });

    test('getAll() -- TypeError', () {
      when(() => localDatabase.getAll(table: any(named: 'table'))).thenAnswer(
        (_) async => [
          {'id': 1},
        ],
      );

      expect(() => bookcaseRepository.getAll(), throwsConversionFailed());
    });

    test('getBookcasesByName() -- LocalDatabaseException', () {
      when(
        () => localDatabase.researchBy(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.getBookcasesByName(name: 'Fantasia'),
        throwsDatabaseException(),
      );
    });

    test('getBookcasesByName() -- TypeError', () {
      when(
        () => localDatabase.researchBy(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenAnswer((_) async => [{}]);

      expect(
        () => bookcaseRepository.getBookcasesByName(name: 'Fantasia'),
        throwsConversionFailed(),
      );
    });

    test('getById() -- LocalDatabaseException', () {
      when(
        () => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.getById(bookcaseId: 1),
        throwsDatabaseException(),
      );
    });

    test('getById() -- TypeError', () {
      when(
        () => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => {'id': 1});

      expect(
        () => bookcaseRepository.getById(bookcaseId: 1),
        throwsConversionFailed(),
      );
    });

    test('countBookcases() -- LocalDatabaseException', () {
      when(
        () => localDatabase.countItems(table: any(named: 'table')),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.countBookcases(),
        throwsDatabaseException(),
      );
    });

    test('insert() -- LocalDatabaseException', () {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.insert(bookcaseModel: bookcaseModel),
        throwsDatabaseException(),
      );
    });

    test('update() -- LocalDatabaseException', () {
      when(
        () => localDatabase.update(
          table: any(named: 'table'),
          values: any(named: 'values'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.update(
          bookcaseModel: bookcaseModel.copyWith(
            colorValue: Colors.blue.toARGB32(),
          ),
        ),
        throwsDatabaseException(),
      );
    });

    test('delete() -- LocalDatabaseException', () {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenThrow(databaseException);

      expect(
        () => bookcaseRepository.delete(bookcaseId: 1),
        throwsDatabaseException(),
      );
    });
  });
}
