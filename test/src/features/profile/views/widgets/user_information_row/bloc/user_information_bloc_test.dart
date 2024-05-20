import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/profile/views/widgets/user_information_row/bloc/user_information_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class BookcaseServiceMock extends Mock implements BookcaseService {}

class LoanServiceMock extends Mock implements LoanService {}

class ReadingServiceMock extends Mock implements ReadingService {}

void main() {
  final bookService = BookServiceMock();
  final bookcaseService = BookcaseServiceMock();
  final loanService = LoanServiceMock();
  final readingService = ReadingServiceMock();
  late UserInformationBloc userInformationBloc;

  setUp(() {
    userInformationBloc = UserInformationBloc(
      bookService,
      bookcaseService,
      loanService,
      readingService,
    );
  });

  group('Test User Information bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => userInformationBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotUserInformationEvent work',
      build: () => userInformationBloc,
      setUp: () {
        when(
          () => bookService.countBooks(),
        ).thenAnswer(
          (_) async => 10,
        );

        when(
          () => bookcaseService.countBookcases(),
        ).thenAnswer(
          (_) async => 10,
        );

        when(
          () => loanService.countLoans(),
        ).thenAnswer(
          (_) async => 10,
        );

        when(
          () => readingService.countReadings(),
        ).thenAnswer(
          (_) async => 10,
        );
      },
      act: (bloc) => bloc.add(GotUserInformationEvent()),
      verify: (_) {
        verify(
          () => bookService.countBooks(),
        ).called(1);

        verify(
          () => bookcaseService.countBookcases(),
        ).called(1);

        verify(
          () => loanService.countLoans(),
        ).called(1);

        verify(
          () => readingService.countReadings(),
        ).called(1);
      },
      expect: () => [
        isA<UserInformationLoadingState>(),
        isA<UserInformationLoadeadState>(),
      ],
    );

    blocTest(
      'Test GotUserInformationEvent work when throw LocalDatabaseException',
      build: () => userInformationBloc,
      setUp: () {
        when(
          () => bookService.countBooks(),
        ).thenAnswer(
          (_) async => 10,
        );

        when(
          () => bookcaseService.countBookcases(),
        ).thenThrow(const LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(GotUserInformationEvent()),
      verify: (_) {
        verify(
          () => bookService.countBooks(),
        ).called(1);

        verify(
          () => bookcaseService.countBookcases(),
        ).called(1);

        verifyNever(
          () => loanService.countLoans(),
        );

        verifyNever(
          () => readingService.countReadings(),
        );
      },
      expect: () => [
        isA<UserInformationLoadingState>(),
        isA<UserInformationErrorState>(),
      ],
    );

    blocTest(
      'Test GotUserInformationEvent work when throw Generic Exception',
      build: () => userInformationBloc,
      setUp: () {
        when(
          () => bookService.countBooks(),
        ).thenAnswer(
          (_) async => 10,
        );

        when(
          () => bookcaseService.countBookcases(),
        ).thenThrow(Exception('Generic Error'));
      },
      act: (bloc) => bloc.add(GotUserInformationEvent()),
      verify: (_) {
        verify(
          () => bookService.countBooks(),
        ).called(1);

        verify(
          () => bookcaseService.countBookcases(),
        ).called(1);

        verifyNever(
          () => loanService.countLoans(),
        );

        verifyNever(
          () => readingService.countReadings(),
        );
      },
      expect: () => [
        isA<UserInformationLoadingState>(),
        isA<UserInformationErrorState>(),
      ],
    );
  });
}
