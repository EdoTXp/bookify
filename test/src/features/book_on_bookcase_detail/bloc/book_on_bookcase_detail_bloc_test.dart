import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/book_on_bookcase_detail/bloc/book_on_bookcase_detail_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseServiceMock extends Mock implements BookcaseService {}

void main() {
  final bookcaseService = BookcaseServiceMock();
  late BookOnBookcaseDetailBloc bookOnBookcaseDetailBloc;

  setUp(
    () => bookOnBookcaseDetailBloc = BookOnBookcaseDetailBloc(
      bookcaseService,
    ),
  );
  group('Test bookOnBookcaseDetail Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => bookOnBookcaseDetailBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'test GotCountOfBookcasesByBookEvent work',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer((_) async => 2),
      act: (bloc) => bloc.add(
        GotCountOfBookcasesByBookEvent(bookId: 'bookId'),
      ),
      verify: (_) => verify(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailLoadedState>(),
      ],
    );

    blocTest(
      'test GotCountOfBookcasesByBookEvent work when throw LocalDatabaseException',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(
        GotCountOfBookcasesByBookEvent(bookId: 'bookId'),
      ),
      verify: (_) => verify(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailErrorState>(),
      ],
    );

    blocTest(
      'test GotCountOfBookcasesByBookEvent work when throw Generic Exception',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(
        GotCountOfBookcasesByBookEvent(bookId: 'bookId'),
      ),
      verify: (_) => verify(
        () => bookcaseService.countBookcasesByBook(
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailErrorState>(),
      ],
    );

    blocTest(
      'test DeletedBookOnBookcaseEvent work',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(
        DeletedBookOnBookcaseEvent(
          bookId: 'bookId',
          bookcaseId: 1,
        ),
      ),
      verify: (_) => verify(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailDeletedState>(),
      ],
    );

    blocTest(
      'test DeletedBookOnBookcaseEvent work when delete error',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(
        DeletedBookOnBookcaseEvent(
          bookId: 'bookId',
          bookcaseId: 1,
        ),
      ),
      verify: (_) => verify(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailErrorState>(),
      ],
    );

    blocTest(
      'test DeletedBookOnBookcaseEvent work throw LocalDatabaseException',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(
        DeletedBookOnBookcaseEvent(
          bookId: 'bookId',
          bookcaseId: 1,
        ),
      ),
      verify: (_) => verify(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailErrorState>(),
      ],
    );

    blocTest(
      'test DeletedBookOnBookcaseEvent work throw Generic Error',
      build: () => bookOnBookcaseDetailBloc,
      setUp: () => when(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(
        DeletedBookOnBookcaseEvent(
          bookId: 'bookId',
          bookcaseId: 1,
        ),
      ),
      verify: (_) => verify(
        () => bookcaseService.deleteBookcaseRelationship(
          bookId: any(named: 'bookId'),
          bookcaseId: any(named: 'bookcaseId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookOnBookcaseDetailLoadingState>(),
        isA<BookOnBookcaseDetailErrorState>(),
      ],
    );
  });
}
