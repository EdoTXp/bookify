import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/data/database/local_database.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  late LocalDatabaseMock localDatabase;
  late LocalDatabaseServiceImpl localDatabaseService;

  setUp(() {
    localDatabase = LocalDatabaseMock();
    localDatabaseService = LocalDatabaseServiceImpl(database: localDatabase);
  });

  group('Test normal CRUD without error ||', () {
    test('delete Database', () async {
      when(() => localDatabase.deleteDatabase()).thenAnswer((_) async {});

      await expectLater(localDatabaseService.deleteDatabase(), completes);
      verify(() => localDatabase.deleteDatabase()).called(1);
    });
  });

  group('Test normal CRUD with error ||', () {
    test('delete Database with -- LocalDatabaseException', () async {
      when(() => localDatabase.deleteDatabase()).thenThrow(
        const LocalDatabaseException(
          LocalDatabaseErrorCode.unknown,
          descriptionMessage: 'Error on database',
        ),
      );

      expect(
        () async => await localDatabaseService.deleteDatabase(),
        throwsA(
          isA<LocalDatabaseException>()
              .having(
                (e) => e.code,
                'code',
                LocalDatabaseErrorCode.unknown,
              )
              .having(
                (e) => e.descriptionMessage,
                'descriptionMessage',
                'Error on database',
              ),
        ),
      );

      verify(() => localDatabase.deleteDatabase()).called(1);
    });
  });
}
