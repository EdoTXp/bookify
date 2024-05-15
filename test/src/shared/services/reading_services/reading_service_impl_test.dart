import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/reading_model.dart';
import 'package:bookify/src/shared/repositories/reading_repository/reading_repository.dart';
import 'package:bookify/src/shared/services/reading_services/reading_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ReadingRepositoryMock extends Mock implements ReadingRepository {}

void main() {
  late List<ReadingModel> readings;
  late ReadingRepositoryMock readingRepository;
  late ReadingServiceImpl readingService;

  setUpAll(() {
    readings = [
      ReadingModel(
        id: 1,
        pagesReaded: 100,
        lastReadingDate: DateTime(2024, 01, 10),
        bookId: 'bookId',
      ),
      ReadingModel(
        id: 2,
        pagesReaded: 100,
        lastReadingDate: DateTime(2024, 01, 10),
        bookId: 'bookId',
      ),
      ReadingModel(
        id: 3,
        pagesReaded: 100,
        lastReadingDate: DateTime(2024, 01, 10),
        bookId: 'bookId',
      ),
    ];

    readingRepository = ReadingRepositoryMock();
    readingService = ReadingServiceImpl(readingRepository);
  });

  tearDownAll(() => readings = []);

  group('test normal CRUD of reading service without error ||', () {
    test('get all', () async {
      when(() => readingRepository.getAll()).thenAnswer(
        (_) async => readings,
      );

      final readingsModel = await readingService.getAll();

      expect(readingsModel.length, equals(3));
      expect(readingsModel[0].id, equals(1));
      expect(readingsModel[0].pagesReaded, equals(100));
      expect(
        readingsModel[0].lastReadingDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(readingsModel[0].bookId, equals('bookId'));
    });

    test('getReadingsByBookTitle', () async {
      when(
        () => readingRepository.getReadingsByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => readings,
      );

      final readingsModel = await readingService.getReadingsByBookTitle(
        title: 'title',
      );

      expect(readingsModel.length, equals(3));
      expect(readingsModel[0].id, equals(1));
      expect(readingsModel[0].pagesReaded, equals(100));
      expect(
        readingsModel[0].lastReadingDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(readingsModel[0].bookId, equals('bookId'));
    });

    test('get by Id', () async {
      when(() => readingRepository.getById(readingId: any(named: 'readingId')))
          .thenAnswer(
        (_) async => readings[1],
      );

      final readingModel = await readingService.getById(readingId: 2);

      expect(readingModel.id, equals(2));
      expect(readingModel.pagesReaded, equals(100));
      expect(
        readingModel.lastReadingDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(readingModel.bookId, equals('bookId'));
    });

    test('insert', () async {
      when(
        () => readingRepository.insert(readingModel: readings[1]),
      ).thenAnswer((_) async => 2);

      final readingId = await readingService.insert(readingModel: readings[1]);

      expect(readingId, equals(2));
    });

    test('update', () async {
      when(
        () => readingRepository.update(
          readingModel: readings[1].copyWith(
            pagesReaded: 200,
          ),
        ),
      ).thenAnswer((_) async => 1);

      final rowUpdated = await readingService.update(
        readingModel: readings[1].copyWith(
          pagesReaded: 200,
        ),
      );

      expect(rowUpdated, equals(1));
    });

    test('delete', () async {
      when(
        () => readingRepository.delete(readingId: any(named: 'readingId')),
      ).thenAnswer((_) async => 1);

      final rowDeleted = await readingService.delete(readingId: 2);

      expect(rowDeleted, equals(1));
    });
  });

  group('test normal CRUD of reading service with error ||', () {
    test('get all -- LocalDatabaseException', () async {
      when(() => readingRepository.getAll())
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('getReadingsByBookTitle -- LocalDatabaseException', () async {
      when(
        () => readingRepository.getReadingsByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.getReadingsByBookTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('get by Id -- LocalDatabaseException', () async {
      when(() => readingRepository.getById(readingId: any(named: 'readingId')))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.getById(readingId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('insert -- LocalDatabaseException', () async {
      when(() => readingRepository.insert(readingModel: readings[1]))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.insert(readingModel: readings[1]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('update -- LocalDatabaseException', () async {
      when(() => readingRepository.update(readingModel: readings[1]))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.update(readingModel: readings[1]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('delete -- LocalDatabaseException', () async {
      when(() => readingRepository.delete(readingId: any(named: 'readingId')))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await readingService.delete(readingId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });
  });
}
