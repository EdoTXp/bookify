import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/reading_model.dart';
import 'package:bookify/src/shared/repositories/reading_repository/reading_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  late List<Map<String, dynamic>> readingsMap;
  late LocalDatabaseMock localDatabase;
  late ReadingRepositoryImpl readingRepository;

  setUpAll(() {
    readingsMap = [
      {
        'id': 1,
        'pagesReaded': 100,
        'lastReadingDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
        'bookId': 'bookId',
      },
      {
        'id': 2,
        'pagesReaded': 100,
        'lastReadingDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
        'bookId': 'bookId',
      },
      {
        'id': 3,
        'pagesReaded': 100,
        'lastReadingDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
        'bookId': 'bookId',
      },
    ];
    localDatabase = LocalDatabaseMock();
    readingRepository = ReadingRepositoryImpl(localDatabase);
  });

  tearDownAll(() => readingsMap = []);

  group('Test normal CRUD reading without error ||', () {
    test('get All', () async {
      when(
        () => localDatabase.getAll(
          table: any(named: 'table'),
          orderColumn: any(named: 'orderColumn'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenAnswer((_) async => readingsMap);

      final readings = await readingRepository.getAll();

      expect(readings.length, equals(3));
      expect(readings[0].id, equals(1));
      expect(readings[0].pagesReaded, equals(100));
      expect(
        readings[0].lastReadingDate,
        equals(
          DateTime(2024, 01, 10),
        ),
      );
      expect(readings[0].bookId, equals('bookId'));
    });

    test('getReadingsByBookTitle', () async {
      when(
        () => localDatabase.getByJoin(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          innerJoinTable: any(named: 'innerJoinTable'),
          onColumn: any(named: 'onColumn'),
          onArgs: any(named: 'onArgs'),
          whereColumn: any(named: 'whereColumn'),
          whereArgs: any(named: 'whereArgs'),
          usingLikeCondition: true,
        ),
      ).thenAnswer((_) async => readingsMap);

      final readings =
          await readingRepository.getReadingsByBookTitle(title: 'title');

      expect(readings.length, equals(3));
      expect(readings[0].id, equals(1));
      expect(readings[0].pagesReaded, equals(100));
      expect(
        readings[0].lastReadingDate,
        equals(
          DateTime(2024, 01, 10),
        ),
      );
      expect(readings[0].bookId, equals('bookId'));
    });

    test('get by Id', () async {
      when(() => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer(
        (_) async => readingsMap.where((element) => element['id'] == 2).first,
      );

      final reading = await readingRepository.getById(readingId: 2);

      expect(reading.id, equals(2));
      expect(reading.pagesReaded, equals(100));
      expect(
        reading.lastReadingDate,
        equals(
          DateTime(2024, 01, 10),
        ),
      );
      expect(reading.bookId, equals('bookId'));
    });

    test('insert', () async {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => 2);

      final readingId = await readingRepository.insert(
        readingModel: ReadingModel.fromMap(
          readingsMap[1],
        ),
      );

      expect(readingId, equals(2));
    });

    test('update', () async {
      when(
        () => localDatabase.update(
          table: any(named: 'table'),
          values: any(named: 'values'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      final rowUpdated = await readingRepository.update(
        readingModel: ReadingModel.fromMap(
          readingsMap[1],
        ),
      );

      expect(rowUpdated, equals(1));
    });

    test('delete', () async {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      final rowDeleted = await readingRepository.delete(readingId: 2);

      expect(rowDeleted, equals(1));
    });
  });

  group('Test normal CRUD reading with error ||', () {
    test('getAll -- TypeError', () async {
      when(
        () => localDatabase.getAll(
          table: any(named: 'table'),
          orderColumn: any(named: 'orderColumn'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenAnswer((_) async => [
            {'id': 1}
          ]);

      expect(
        () async => await readingRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar as leituras no database'),
      );
    });

    test('get All -- LocalDatabaseException', () async {
      when(
        () => localDatabase.getAll(
          table: any(named: 'table'),
          orderColumn: any(named: 'orderColumn'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await readingRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getReadingsByBookTitle -- TypeError', () async {
      when(
        () => localDatabase.getByJoin(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          innerJoinTable: any(named: 'innerJoinTable'),
          onColumn: any(named: 'onColumn'),
          onArgs: any(named: 'onArgs'),
          whereColumn: any(named: 'whereColumn'),
          whereArgs: any(named: 'whereArgs'),
          usingLikeCondition: true,
        ),
      ).thenAnswer((_) async => [
            {'id': 1}
          ]);

      expect(
        () async =>
            await readingRepository.getReadingsByBookTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar as leituras no database'),
      );
    });

    test('getReadingsByBookTitle -- LocalDatabaseException', () async {
      when(
        () => localDatabase.getByJoin(
          table: any(named: 'table'),
          columns: any(named: 'columns'),
          innerJoinTable: any(named: 'innerJoinTable'),
          onColumn: any(named: 'onColumn'),
          onArgs: any(named: 'onArgs'),
          whereColumn: any(named: 'whereColumn'),
          whereArgs: any(named: 'whereArgs'),
          usingLikeCondition: true,
        ),
      ).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await readingRepository.getReadingsByBookTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getById -- TypeError', () async {
      when(() => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => {'id': 1});

      expect(
        () async => await readingRepository.getById(readingId: 1),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException &&
              e.message == 'Impossível encontrar a leitura no database',
        ),
      );
    });

    test('getById -- LocalDatabaseException', () async {
      when(() => localDatabase.getItemById(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await readingRepository.getById(readingId: 1),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database',
        ),
      );
    });

    test('insert -- LocalDatabaseException', () async {
      when(() => localDatabase.insert(
              table: any(named: 'table'), values: any(named: 'values')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await readingRepository.insert(
            readingModel: ReadingModel.fromMap(readingsMap[0])),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database',
        ),
      );
    });

    test('update -- LocalDatabaseException', () async {
      when(() => localDatabase.update(
          table: any(named: 'table'),
          values: any(named: 'values'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenThrow(
        const LocalDatabaseException(
          'Error on database',
        ),
      );

      expect(
        () async => await readingRepository.update(
            readingModel: ReadingModel.fromMap(readingsMap[0])),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database',
        ),
      );
    });

    test('delete -- LocalDatabaseException', () async {
      when(() => localDatabase.delete(
              table: any(named: 'table'),
              idColumn: any(named: 'idColumn'),
              id: any(named: 'id')))
          .thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await readingRepository.delete(readingId: 1),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database',
        ),
      );
    });
  });
}
