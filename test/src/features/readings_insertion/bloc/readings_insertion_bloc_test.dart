import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/readings_insertion/bloc/readings_insertion_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/reading_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class ReadingServiceMock extends Mock implements ReadingService {}

void main() {
  final bookService = BookServiceMock();
  final readingService = ReadingServiceMock();
  late ReadingsInsertionBloc readingsInsertionBloc;

  const readingModel = ReadingModel(
    bookId: 'bookId',
    pagesReaded: 0,
  );

  setUp(() {
    readingsInsertionBloc = ReadingsInsertionBloc(
      bookService,
      readingService,
    );
  });

  group('Test Reading Insertion Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => readingsInsertionBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test InsertedLoanEvent work',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenAnswer((_) async => 1);
      },
      act: (bloc) => bloc.add(InsertedReadingsEvent(bookId: 'bookId')),
      verify: (_) {
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verify(() => readingService.insert(
              readingModel: readingModel,
            )).called(1);
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when pageCount != 0',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updatePageCount(
              id: any(named: 'id'),
              pageCount: any(named: 'pageCount'),
            )).thenAnswer((_) async => 1);
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenAnswer((_) async => 1);
      },
      act: (bloc) =>
          bloc.add(InsertedReadingsEvent(bookId: 'bookId', pagesUpdated: 100)),
      verify: (_) {
        verify(() => bookService.updatePageCount(
              id: any(named: 'id'),
              pageCount: any(named: 'pageCount'),
            )).called(1);
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verify(() => readingService.insert(
              readingModel: readingModel,
            )).called(1);
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when pageCount != 0 with error update',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updatePageCount(
              id: any(named: 'id'),
              pageCount: any(named: 'pageCount'),
            )).thenAnswer((_) async => 0);
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenAnswer((_) async => 1);
      },
      act: (bloc) =>
          bloc.add(InsertedReadingsEvent(bookId: 'bookId', pagesUpdated: 100)),
      verify: (_) {
        verify(() => bookService.updatePageCount(
              id: any(named: 'id'),
              pageCount: any(named: 'pageCount'),
            )).called(1);
        verifyNever(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            ));
        verifyNever(() => readingService.insert(
              readingModel: readingModel,
            ));
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when update status error',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 0);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenAnswer((_) async => 1);
      },
      act: (bloc) => bloc.add(InsertedReadingsEvent(bookId: 'bookId')),
      verify: (_) {
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verifyNever(() => readingService.insert(
              readingModel: readingModel,
            ));
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when reading insertion error',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenAnswer((_) async => 0);
      },
      act: (bloc) => bloc.add(InsertedReadingsEvent(bookId: 'bookId')),
      verify: (_) {
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verify(() => readingService.insert(
              readingModel: readingModel,
            )).called(1);
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when throw LocalDatabaseException',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenThrow(const LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(InsertedReadingsEvent(bookId: 'bookId')),
      verify: (_) {
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verify(() => readingService.insert(
              readingModel: readingModel,
            )).called(1);
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedLoanEvent work when throw Generic Exception',
      build: () => readingsInsertionBloc,
      setUp: () {
        when(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).thenAnswer((_) async => 1);
        when(() => readingService.insert(
              readingModel: readingModel,
            )).thenThrow(Exception('Generic Error'));
      },
      act: (bloc) => bloc.add(InsertedReadingsEvent(bookId: 'bookId')),
      verify: (_) {
        verify(() => bookService.updateStatus(
              id: any(named: 'id'),
              status: BookStatus.reading,
            )).called(1);
        verify(() => readingService.insert(
              readingModel: readingModel,
            )).called(1);
      },
      expect: () => [
        isA<ReadingsInsertionLoadingState>(),
        isA<ReadingsInsertionErrorState>(),
      ],
    );
  });
}
