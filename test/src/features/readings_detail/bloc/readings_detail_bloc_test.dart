import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/readings_detail/bloc/readings_detail_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/reading_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ReadingServiceMock extends Mock implements ReadingService {}

class BookServiceMock extends Mock implements BookService {}

void main() {
  final readingService = ReadingServiceMock();
  final bookService = BookServiceMock();
  late ReadingsDetailBloc readingsDetailBloc;

  final readingModel = ReadingModel(
    id: 1,
    lastReadingDate: DateTime(2024, 10, 22),
    pagesReaded: 100,
    bookId: 'bookId',
  );

  setUp(
    () => readingsDetailBloc = ReadingsDetailBloc(
      bookService,
      readingService,
    ),
  );

  group('Test Reading Detail Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => readingsDetailBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test UpdatedReadingsEvent work',
      build: () => readingsDetailBloc,
      setUp: () => when(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(
        UpdatedReadingsEvent(
          readingModel: readingModel,
        ),
      ),
      verify: (_) => verify(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailUpdatedState>(),
      ],
    );

    blocTest(
      'Test UpdatedReadingsEvent work when update error',
      build: () => readingsDetailBloc,
      setUp: () => when(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(
        UpdatedReadingsEvent(
          readingModel: readingModel,
        ),
      ),
      verify: (_) => verify(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test UpdatedReadingsEvent work when throw LocalDatabaseException',
      build: () => readingsDetailBloc,
      setUp: () => when(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).thenThrow(
        const LocalDatabaseException('Error on Database'),
      ),
      act: (bloc) => bloc.add(
        UpdatedReadingsEvent(
          readingModel: readingModel,
        ),
      ),
      verify: (_) => verify(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test UpdatedReadingsEvent work when throw Generic Exception',
      build: () => readingsDetailBloc,
      setUp: () => when(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        UpdatedReadingsEvent(
          readingModel: readingModel,
        ),
      ),
      verify: (_) => verify(
        () => readingService.update(
          readingModel: readingModel,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test FinishedReadingsEvent work',
      build: () => readingsDetailBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).thenAnswer((_) async => 1);
      },
      act: (bloc) => bloc.add(
        FinishedReadingsEvent(
          readingId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailFinishedState>(),
      ],
    );

    blocTest(
      'Test FinishedReadingsEvent work when book update status error',
      build: () => readingsDetailBloc,
      setUp: () => when(
        () => bookService.updateStatus(
          id: any(named: 'id'),
          status: BookStatus.library,
        ),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(
        FinishedReadingsEvent(
          readingId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).called(1);
        verifyNever(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        );
      },
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test FinishedReadingsEvent work when delete error',
      build: () => readingsDetailBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).thenAnswer((_) async => 0);
      },
      act: (bloc) => bloc.add(
        FinishedReadingsEvent(
          readingId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test FinishedReadingsEvent work when throw LocalDatabaseException',
      build: () => readingsDetailBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).thenThrow(
          const LocalDatabaseException('Error on Database'),
        );
      },
      act: (bloc) => bloc.add(
        FinishedReadingsEvent(
          readingId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );

    blocTest(
      'Test FinishedReadingsEvent work when throw  Generic Exception',
      build: () => readingsDetailBloc,
      setUp: () {
        when(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).thenThrow(
          Exception('Generic Error'),
        );
      },
      act: (bloc) => bloc.add(
        FinishedReadingsEvent(
          readingId: 1,
          bookId: 'bookId',
        ),
      ),
      verify: (_) {
        verify(
          () => bookService.updateStatus(
            id: any(named: 'id'),
            status: BookStatus.library,
          ),
        ).called(1);
        verify(
          () => readingService.delete(
            readingId: any(named: 'readingId'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<ReadingsDetailLoadingState>(),
        isA<ReadingsDetailErrorState>(),
      ],
    );
  });
}
