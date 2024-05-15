import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/loan/bloc/loan_bloc.dart';
import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class LoanServiceMock extends Mock implements LoanService {}

class ContactsServiceMock extends Mock implements ContactsService {}

void main() {
  final bookService = BookServiceMock();
  final loanService = LoanServiceMock();
  final contactsService = ContactsServiceMock();
  late LoanBloc loanBloc;

  setUp(() {
    loanBloc = LoanBloc(
      bookService,
      loanService,
      contactsService,
    );
  });

  group('Test Loan Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => loanBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotAllLoansEvent work',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getAll()).thenAnswer(
          (_) async => [
            LoanModel(
              id: 1,
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
        when(() => bookService.getBookById(id: any(named: 'id'))).thenAnswer(
          (_) async => BookModel(
            id: 'id',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 3.4,
            ratingsCount: 12,
          ),
        );

        when(() => contactsService.getContactById(id: any(named: 'id')))
            .thenAnswer(
          (_) async => ContactDto(
            id: 'id',
            name: 'name',
            photo: Uint8List(32),
            phoneNumber: 'number',
          ),
        );
      },
      act: (bloc) => bloc.add(GotAllLoansEvent()),
      verify: (_) {
        verify(() => loanService.getAll()).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
        verify(() => contactsService.getContactById(id: any(named: 'id')))
            .called(1);
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanLoadedState>(),
      ],
    );

    blocTest(
      'Test GotAllLoansEvent work when loans are empty',
      build: () => loanBloc,
      setUp: () => when(() => loanService.getAll()).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(GotAllLoansEvent()),
      verify: (_) {
        verify(() => loanService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanEmptyState>(),
      ],
    );

    blocTest(
      'Test GotAllLoansEvent work when loan id is empty',
      build: () => loanBloc,
      setUp: () => when(() => loanService.getAll()).thenAnswer(
        (_) async => [
          LoanModel(
            observation: 'observation',
            loanDate: DateTime(2024, 03, 06),
            devolutionDate: DateTime(2024, 04, 06),
            idContact: 'idContact',
            bookId: 'bookId',
          ),
        ],
      ),
      act: (bloc) => bloc.add(GotAllLoansEvent()),
      verify: (_) {
        verify(() => loanService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );

    blocTest(
      'Test GotAllLoansEvent work when throw LocalDatabaseException',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getAll()).thenAnswer(
          (_) async => [
            LoanModel(
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenThrow(
          const LocalDatabaseException('Error on Database'),
        );
      },
      act: (bloc) => bloc.add(GotAllLoansEvent()),
      verify: (_) {
        verify(() => loanService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );

    blocTest(
      'Test GotAllLoansEvent work when throw Generic Exception',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getAll()).thenAnswer(
          (_) async => [
            LoanModel(
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenThrow(
          Exception('Generic Error'),
        );
      },
      act: (bloc) => bloc.add(GotAllLoansEvent()),
      verify: (_) {
        verify(() => loanService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );

    blocTest(
      'Test FindedLoanByBookTitleEvent work',
      build: () => loanBloc,
      setUp: () {
        when(
          () => loanService.getLoansByBookTitle(
            title: any(named: 'title'),
          ),
        ).thenAnswer(
          (_) async => [
            LoanModel(
              id: 1,
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
        when(() => bookService.getBookById(id: any(named: 'id'))).thenAnswer(
          (_) async => BookModel(
            id: 'id',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 3.4,
            ratingsCount: 12,
          ),
        );

        when(() => contactsService.getContactById(id: any(named: 'id')))
            .thenAnswer(
          (_) async => ContactDto(
            id: 'id',
            name: 'name',
            photo: Uint8List(32),
            phoneNumber: 'number',
          ),
        );
      },
      act: (bloc) => bloc.add(
        FindedLoanByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(
          () => loanService.getLoansByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
        verify(() => contactsService.getContactById(id: any(named: 'id')))
            .called(1);
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanLoadedState>(),
      ],
    );

    blocTest(
      'Test FindedLoanByBookTitleEvent work when loans are empty',
      build: () => loanBloc,
      setUp: () => when(
        () => loanService.getLoansByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc
          .add(FindedLoanByBookTitleEvent(searchQueryName: 'searchQueryName')),
      verify: (_) {
        verify(
          () => loanService.getLoansByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanNotFoundState>(),
      ],
    );

    blocTest(
      'Test FindedLoanByBookTitleEvent work when loan id is empty',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getLoansByBookTitle(title: any(named: 'title')))
            .thenAnswer(
          (_) async => [
            LoanModel(
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
      },
      act: (bloc) => bloc
          .add(FindedLoanByBookTitleEvent(searchQueryName: 'searchQueryName')),
      verify: (_) {
        verify(
          () => loanService.getLoansByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );

    blocTest(
      'Test FindedLoanByBookTitleEvent work when throw LocalDatabaseException',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getLoansByBookTitle(title: any(named: 'title')))
            .thenAnswer(
          (_) async => [
            LoanModel(
              id: 1,
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
        );
        when(
          () => bookService.getBookById(
            id: any(named: 'id'),
          ),
        ).thenThrow(
          const LocalDatabaseException('Error on Database'),
        );
      },
      act: (bloc) => bloc.add(
        FindedLoanByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(() =>
                loanService.getLoansByBookTitle(title: any(named: 'title')))
            .called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );

    blocTest(
      'Test FindedLoanByBookTitleEvent work when throw Generic Exception',
      build: () => loanBloc,
      setUp: () {
        when(() => loanService.getLoansByBookTitle(title: any(named: 'title')))
            .thenAnswer(
          (_) async => [
            LoanModel(
              id: 1,
              observation: 'observation',
              loanDate: DateTime(2024, 03, 06),
              devolutionDate: DateTime(2024, 04, 06),
              idContact: 'idContact',
              bookId: 'bookId',
            ),
          ],
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
        FindedLoanByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(
          () => loanService.getLoansByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
        verifyNever(() => contactsService.getContactById(id: any(named: 'id')));
      },
      expect: () => [
        isA<LoanLoadingState>(),
        isA<LoanErrorState>(),
      ],
    );
  });
}
