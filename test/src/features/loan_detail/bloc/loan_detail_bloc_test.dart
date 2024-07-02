import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/loan_detail/bloc/loan_detail_bloc.dart';
import 'package:bookify/src/core/dtos/contact_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/models/loan_model.dart';
import 'package:bookify/src/core/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class LoanServiceMock extends Mock implements LoanService {}

class BookServiceMock extends Mock implements BookService {}

class ContactsServiceMock extends Mock implements ContactsService {}

class NotificationsServiceMock extends Mock implements NotificationsService {}

void main() {
  final bookService = BookServiceMock();
  final loanService = LoanServiceMock();
  final contactsService = ContactsServiceMock();
  final notificationsService = NotificationsServiceMock();
  late LoanDetailBloc bloc;

  final loanModel = LoanModel(
    id: 1,
    observation: 'observation',
    loanDate: DateTime(2023, 02, 11),
    devolutionDate: DateTime(2023, 02, 15),
    idContact: 'idContact',
    bookId: 'bookId',
  );

  final bookModel = BookModel(
    id: 'bookId',
    title: 'bookTitlePreview',
    authors: [AuthorModel.withEmptyName()],
    publisher: 'publisher',
    description: 'description',
    categories: [CategoryModel.withEmptyName()],
    pageCount: 320,
    imageUrl: 'bookImagePreview',
    buyLink: 'buyLink',
    averageRating: 2.3,
    ratingsCount: 120,
  );

  const contactDto = ContactDto(
    id: 'ContactId',
    name: 'Alice',
  );

  setUp(() {
    bloc = LoanDetailBloc(
      loanService,
      bookService,
      contactsService,
      notificationsService,
    );
  });

  group('Test LoanDetail bloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'test if GotLoanDetailEvent work',
      build: () => bloc,
      setUp: () {
        when(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).thenAnswer(
          (_) async => loanModel,
        );

        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async => bookModel,
        );

        when(
          () => contactsService.getContactById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async => contactDto,
        );
      },
      act: (bloc) => bloc.add(
        GotLoanDetailEvent(id: 1),
      ),
      verify: (_) {
        verify(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
        verify(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => contactsService.getContactById(
            id: any(named: 'id'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailLoadedState>(),
      ],
    );

    blocTest(
      'test if GotLoanDetailEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () {
        when(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).thenAnswer(
          (_) async => loanModel,
        );

        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenThrow(
          const LocalDatabaseException('Error on database'),
        );
      },
      act: (bloc) => bloc.add(
        GotLoanDetailEvent(id: 1),
      ),
      verify: (_) {
        verify(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
        verify(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verifyNever(
          () => contactsService.getContactById(
            id: any(named: 'id'),
          ),
        );
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );

    blocTest(
      'test if GotLoanDetailEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () {
        when(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).thenAnswer(
          (_) async => loanModel,
        );

        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenThrow(
          Exception('Generic Error'),
        );
      },
      act: (bloc) => bloc.add(
        GotLoanDetailEvent(id: 1),
      ),
      verify: (_) {
        verify(
          () => loanService.getById(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
        verify(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verifyNever(
          () => contactsService.getContactById(
            id: any(named: 'id'),
          ),
        );
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );

    blocTest(
      'test if FinishedLoanDetailEvent work',
      build: () => bloc,
      setUp: () {
        when(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async {},
        );

        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).thenAnswer(
          (_) async => 1,
        );
      },
      act: (bloc) => bloc.add(
        FinishedLoanDetailEvent(
          loanId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailFinishedState>(),
      ],
    );

    blocTest(
      'test if FinishedLoanDetailEvent work when bookStatusUpdated != 1',
      build: () => bloc,
      setUp: () {
        when(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async {},
        );

        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).thenAnswer(
          (_) async => -1,
        );
      },
      act: (bloc) => bloc.add(
        FinishedLoanDetailEvent(
          loanId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).called(1);
        verifyNever(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        );
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );

    blocTest(
      'test if FinishedLoanDetailEvent work when loanRemovedRow != 1',
      build: () => bloc,
      setUp: () {
        when(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async {},
        );

        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).thenAnswer(
          (_) async => -1,
        );
      },
      act: (bloc) => bloc.add(
        FinishedLoanDetailEvent(
          loanId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );

    blocTest(
      'test if FinishedLoanDetailEvent work throw LocalDatabaseException',
      build: () => bloc,
      setUp: () {
        when(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async {},
        );

        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).thenThrow(const LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(
        FinishedLoanDetailEvent(
          loanId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );

    blocTest(
      'test if FinishedLoanDetailEvent work throw Generic Exception',
      build: () => bloc,
      setUp: () {
        when(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).thenAnswer(
          (_) async {},
        );

        when(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).thenThrow(Exception('Generic Error'));
      },
      act: (bloc) => bloc.add(
        FinishedLoanDetailEvent(
          loanId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => notificationsService.cancelNotificationById(
            id: any(named: 'id'),
          ),
        ).called(1);
        verify(
          () => bookService.updateStatus(
            id: 'bookId',
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => loanService.delete(
            loanId: any(named: 'loanId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<LoanDetailLoadingState>(),
        isA<LoanDetailErrorState>(),
      ],
    );
  });
}
