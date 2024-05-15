import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/repositories/loan_repository/loan_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  late List<Map<String, dynamic>> loansMap;
  late LocalDatabaseMock localDatabase;
  late LoanRepositoryImpl loanRepository;

  setUpAll(
    () {
      loansMap = [
        {
          'id': 1,
          'observation': 'observation',
          'loanDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
          'devolutionDate':
              DateTime(DateTime.april, 2024).millisecondsSinceEpoch,
          'idContact': 'idContact',
          'bookId': 'bookId',
        },
        {
          'id': 2,
          'observation': 'observation',
          'loanDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
          'devolutionDate':
              DateTime(DateTime.april, 2024).millisecondsSinceEpoch,
          'idContact': 'idContact',
          'bookId': 'bookId',
        },
        {
          'id': 3,
          'observation': 'observation',
          'loanDate': DateTime(2024, 01, 10).millisecondsSinceEpoch,
          'devolutionDate':
              DateTime(DateTime.april, 2024).millisecondsSinceEpoch,
          'idContact': 'idContact',
          'bookId': 'bookId',
        },
      ];

      localDatabase = LocalDatabaseMock();
      loanRepository = LoanRepositoryImpl(localDatabase);
    },
  );

  tearDownAll(() => loansMap = []);

  group('Test normal CRUD loan without error ||', () {
    test('get All', () async {
      when(
        () => localDatabase.getAll(
          table: any(named: 'table'),
          orderColumn: any(named: 'orderColumn'),
          orderBy: any(named: 'orderBy'),
        ),
      ).thenAnswer((_) async => loansMap);

      final loansModel = await loanRepository.getAll();

      expect(loansModel.length, equals(3));
      expect(loansModel[0].id, equals(1));
      expect(loansModel[0].observation, equals('observation'));
      expect(
        loansModel[0].loanDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(
          loansModel[0].devolutionDate,
          equals(
            DateTime(DateTime.april, 2024),
          ));
      expect(loansModel[0].idContact, equals('idContact'));
      expect(loansModel[0].bookId, equals('bookId'));
    });

    test('getLoansByBookTitle', () async {
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
      ).thenAnswer((_) async => loansMap);

      final loansModel =
          await loanRepository.getLoansByBookTitle(title: 'title');

      expect(loansModel.length, equals(3));
      expect(loansModel[0].id, equals(1));
      expect(loansModel[0].observation, equals('observation'));
      expect(
        loansModel[0].loanDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(
          loansModel[0].devolutionDate,
          equals(
            DateTime(DateTime.april, 2024),
          ));
      expect(loansModel[0].idContact, equals('idContact'));
      expect(loansModel[0].bookId, equals('bookId'));
    });

    test('get by Id', () async {
      when(() => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer(
        (_) async => loansMap.where((element) => element['id'] == 2).first,
      );

      final loanModel = await loanRepository.getById(loanId: 2);

      expect(loanModel.id, equals(2));
      expect(loanModel.observation, equals('observation'));
      expect(
        loanModel.loanDate,
        equals(DateTime(2024, 01, 10)),
      );
      expect(
          loanModel.devolutionDate,
          equals(
            DateTime(DateTime.april, 2024),
          ));
      expect(loanModel.idContact, equals('idContact'));
      expect(loanModel.bookId, equals('bookId'));
    });

    test('insert', () async {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => 2);

      final loanId = await loanRepository.insert(
        loanModel: LoanModel.fromMap(
          loansMap[1],
        ),
      );

      expect(loanId, equals(2));
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

      final rowUpdated = await loanRepository.update(
        loanModel: LoanModel.fromMap(
          loansMap[1],
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

      final rowDeleted = await loanRepository.delete(loanId: 2);

      expect(rowDeleted, equals(1));
    });
  });

  group('Test normal CRUD loan with error ||', () {
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
        () async => await loanRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar os empréstimos no database'),
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
        () async => await loanRepository.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('getLoansByBookTitle -- TypeError', () async {
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
        () async => await loanRepository.getLoansByBookTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível encontrar os empréstimos no database'),
      );
    });

    test('getLoansByBookTitle -- LocalDatabaseException', () async {
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
        () async => await loanRepository.getLoansByBookTitle(title: 'title'),
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
        () async => await loanRepository.getById(loanId: 1),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException &&
              e.message == 'Impossível encontrar o empréstimo no database',
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
        () async => await loanRepository.getById(loanId: 1),
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
        () async => await loanRepository.insert(
            loanModel: LoanModel.fromMap(loansMap[0])),
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
        () async => await loanRepository.update(
            loanModel: LoanModel.fromMap(loansMap[0])),
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
        () async => await loanRepository.delete(loanId: 1),
        throwsA(
          (Exception e) =>
              e is LocalDatabaseException && e.message == 'Error on database',
        ),
      );
    });
  });
}
