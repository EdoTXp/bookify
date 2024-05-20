import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/repositories/loan_repository/loan_repository.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoanRepositoryMock extends Mock implements LoanRepository {}

void main() {
  late List<LoanModel> loans;
  late LoanRepositoryMock loanRepository;
  late LoanServiceImpl loanService;

  setUpAll(() {
    loans = [
      LoanModel(
        id: 1,
        observation: 'observation',
        loanDate: DateTime(2024, 01, 10),
        devolutionDate: DateTime(DateTime.april, 2024),
        idContact: 'idContact',
        bookId: 'bookId',
      ),
      LoanModel(
        id: 2,
        observation: 'observation',
        loanDate: DateTime(2024, 01, 10),
        devolutionDate: DateTime(DateTime.april, 2024),
        idContact: 'idContact',
        bookId: 'bookId',
      ),
      LoanModel(
        id: 3,
        observation: 'observation',
        loanDate: DateTime(2024, 01, 10),
        devolutionDate: DateTime(DateTime.april, 2024),
        idContact: 'idContact',
        bookId: 'bookId',
      ),
    ];

    loanRepository = LoanRepositoryMock();
    loanService = LoanServiceImpl(loanRepository);
  });

  tearDownAll(() => loans = []);

  group('test normal CRUD of loan service without error ||', () {
    test('get all', () async {
      when(() => loanRepository.getAll()).thenAnswer(
        (_) async => loans,
      );

      final loansModel = await loanService.getAll();

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
        () => loanRepository.getLoansByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => loans,
      );

      final loansModel = await loanService.getLoansByBookTitle(title: 'title');

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
      when(() => loanRepository.getById(loanId: any(named: 'loanId')))
          .thenAnswer(
        (_) async => loans[1],
      );

      final loanModel = await loanService.getById(loanId: 2);

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

    test('countLoans', () async {
      when(
        () => loanRepository.countLoans(),
      ).thenAnswer(
        (_) async => 10,
      );

      final loansCount = await loanService.countLoans();
      expect(loansCount, equals(10));
    });

    test('insert', () async {
      when(
        () => loanRepository.insert(loanModel: loans[1]),
      ).thenAnswer((_) async => 2);

      final loanId = await loanService.insert(loanModel: loans[1]);

      expect(loanId, equals(2));
    });

    test('update', () async {
      when(
        () => loanRepository.update(
          loanModel: loans[1].copyWith(
            devolutionDate: DateTime(DateTime.august),
          ),
        ),
      ).thenAnswer((_) async => 1);

      final rowUpdated = await loanService.update(
        loanModel: loans[1].copyWith(
          devolutionDate: DateTime(DateTime.august),
        ),
      );

      expect(rowUpdated, equals(1));
    });

    test('delete', () async {
      when(
        () => loanRepository.delete(loanId: any(named: 'loanId')),
      ).thenAnswer((_) async => 1);

      final rowDeleted = await loanService.delete(loanId: 2);

      expect(rowDeleted, equals(1));
    });
  });

  group('test normal CRUD of loan service with error ||', () {
    test('get all -- LocalDatabaseException', () async {
      when(() => loanRepository.getAll())
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.getAll(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('getLoansByBookTitle -- LocalDatabaseException', () async {
      when(
        () => loanRepository.getLoansByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.getLoansByBookTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('get by Id -- LocalDatabaseException', () async {
      when(() => loanRepository.getById(loanId: any(named: 'loanId')))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.getById(loanId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('countLoans -- LocalDatabaseException', () async {
      when(
        () => loanRepository.countLoans(),
      ).thenThrow(const LocalDatabaseException('Error on Database'));
      
      expect(
        () async => await loanService.countLoans(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('insert -- LocalDatabaseException', () async {
      when(() => loanRepository.insert(loanModel: loans[1]))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.insert(loanModel: loans[1]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('update -- LocalDatabaseException', () async {
      when(() => loanRepository.update(loanModel: loans[1]))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.update(loanModel: loans[1]),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });

    test('delete -- LocalDatabaseException', () async {
      when(() => loanRepository.delete(loanId: any(named: 'loanId')))
          .thenThrow(const LocalDatabaseException('Error on Database'));

      expect(
        () async => await loanService.delete(loanId: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on Database'),
      );
    });
  });
}
