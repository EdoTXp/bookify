import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/loan_insertion/bloc/loan_insertion_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/loan_model.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoanServiceMock extends Mock implements LoanService {}

class BookServiceMock extends Mock implements BookService {}

class NotificationsServiceMock extends Mock implements NotificationsService {}

class CustomNotificationFake extends Fake implements CustomNotificationModel {}

void main() {
  final bookService = BookServiceMock();
  final loanService = LoanServiceMock();
  final notificationsService = NotificationsServiceMock();
  late LoanInsertionBloc loanInsertionBloc;

  final loanModel = LoanModel(
    observation: 'observation',
    loanDate: DateTime(2024, 02, 23),
    devolutionDate: DateTime(2024, 03, 22),
    idContact: 'idContact',
    bookId: 'bookId',
  );

  final customNotification = CustomNotificationFake();

  setUp(() {
    registerFallbackValue(customNotification);

    loanInsertionBloc = LoanInsertionBloc(
      bookService,
      loanService,
      notificationsService,
    );
  });

  group('Test Loan Insertion Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => loanInsertionBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test InsertedLoanEvent work',
      build: () => loanInsertionBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).thenAnswer(
          (_) async => 1,
        );
        when(
          () => loanService.insert(loanModel: loanModel),
        ).thenAnswer(
          (_) async => 1,
        );
        when(
          () => notificationsService.scheduleNotification(any()),
        ).thenAnswer((_) async {});
      },
      act: (bloc) => bloc.add(
        InsertedLoanInsertionEvent(
          observation: 'observation',
          loanDate: DateTime(2024, 02, 23),
          devolutionDate: DateTime(2024, 03, 22),
          contactName: 'contactName',
          idContact: 'idContact',
          bookId: 'bookId',
          bookTitle: 'bookTitle',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).called(1);
        verify(
          () => loanService.insert(loanModel: loanModel),
        ).called(1);
        verify(
          () => notificationsService.scheduleNotification(any()),
        ).called(1);
      },
      expect: () => [
        isA<LoanInsertionLoadingState>(),
        isA<LoanInsertionInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when bookstatus is 0',
      build: () => loanInsertionBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).thenAnswer(
          (_) async => 0,
        );
      },
      act: (bloc) => bloc.add(
        InsertedLoanInsertionEvent(
          observation: 'observation',
          loanDate: DateTime(2024, 02, 23),
          devolutionDate: DateTime(2024, 03, 22),
          contactName: 'contactName',
          idContact: 'idContact',
          bookId: 'bookId',
          bookTitle: 'bookTitle',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).called(1);
        verifyNever(
          () => loanService.insert(loanModel: loanModel),
        );
        verifyNever(
          () => notificationsService.scheduleNotification(
            customNotification,
          ),
        );
      },
      expect: () => [
        isA<LoanInsertionLoadingState>(),
        isA<LoanInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when loanId is 0',
      build: () => loanInsertionBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).thenAnswer(
          (_) async => 1,
        );
        when(
          () => loanService.insert(loanModel: loanModel),
        ).thenAnswer(
          (_) async => 0,
        );
      },
      act: (bloc) => bloc.add(
        InsertedLoanInsertionEvent(
          observation: 'observation',
          loanDate: DateTime(2024, 02, 23),
          devolutionDate: DateTime(2024, 03, 22),
          contactName: 'contactName',
          idContact: 'idContact',
          bookId: 'bookId',
          bookTitle: 'bookTitle',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).called(1);
        verify(
          () => loanService.insert(loanModel: loanModel),
        ).called(1);
        verifyNever(
          () => notificationsService.scheduleNotification(
            customNotification,
          ),
        );
      },
      expect: () => [
        isA<LoanInsertionLoadingState>(),
        isA<LoanInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when throw LocalDatabaseException',
      build: () => loanInsertionBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).thenThrow(const LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(
        InsertedLoanInsertionEvent(
          observation: 'observation',
          loanDate: DateTime(2024, 02, 23),
          devolutionDate: DateTime(2024, 03, 22),
          contactName: 'contactName',
          idContact: 'idContact',
          bookId: 'bookId',
          bookTitle: 'bookTitle',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).called(1);
        verifyNever(
          () => loanService.insert(loanModel: loanModel),
        );
        verifyNever(
          () => notificationsService.scheduleNotification(
            customNotification,
          ),
        );
      },
      expect: () => [
        isA<LoanInsertionLoadingState>(),
        isA<LoanInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when throw Generic Exception',
      build: () => loanInsertionBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).thenThrow(Exception('Generic Error'));
      },
      act: (bloc) => bloc.add(
        InsertedLoanInsertionEvent(
          observation: 'observation',
          loanDate: DateTime(2024, 02, 23),
          devolutionDate: DateTime(2024, 03, 22),
          contactName: 'contactName',
          idContact: 'idContact',
          bookId: 'bookId',
          bookTitle: 'bookTitle',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.loaned,
          ),
        ).called(1);
        verifyNever(
          () => loanService.insert(loanModel: loanModel),
        );
        verifyNever(
          () => notificationsService.scheduleNotification(
            customNotification,
          ),
        );
      },
      expect: () => [
        isA<LoanInsertionLoadingState>(),
        isA<LoanInsertionErrorState>(),
      ],
    );
  });
}
