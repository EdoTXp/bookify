import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/readings/bloc/readings_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
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
  late ReadingsBloc readingsBloc;

  setUp(() {
    readingsBloc = ReadingsBloc(
      bookService,
      readingService,
    );
  });

  group('Test Readings Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => readingsBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotAllReadingsEvent work',
      build: () => readingsBloc,
      setUp: () {
        when(() => readingService.getAll()).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
      },
      act: (bloc) => bloc.add(GotAllReadingsEvent()),
      verify: (_) {
        verify(() => readingService.getAll()).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsLoadedState>(),
      ],
    );

    blocTest(
      'Test GotAllReadingsEvent work when readings are empty',
      build: () => readingsBloc,
      setUp: () => when(() => readingService.getAll()).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(GotAllReadingsEvent()),
      verify: (_) {
        verify(() => readingService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsEmptyState>(),
      ],
    );

    blocTest(
      'Test GotAllReadingsEvent work when reading id is empty',
      build: () => readingsBloc,
      setUp: () => when(() => readingService.getAll()).thenAnswer(
        (_) async => [
          ReadingModel(
            pagesReaded: 100,
            lastReadingDate: DateTime(2024, 03, 06),
            bookId: 'bookId',
          ),
        ],
      ),
      act: (bloc) => bloc.add(GotAllReadingsEvent()),
      verify: (_) {
        verify(() => readingService.getAll()).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );

    blocTest(
      'Test GotAllReadingsEvent work when throw LocalDatabaseException',
      build: () => readingsBloc,
      setUp: () {
        when(() => readingService.getAll()).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
      act: (bloc) => bloc.add(GotAllReadingsEvent()),
      verify: (_) {
        verify(() => readingService.getAll()).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );

    blocTest(
      'Test GotAllReadingsEvent work when throw Generic Exception',
      build: () => readingsBloc,
      setUp: () {
        when(() => readingService.getAll()).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
      act: (bloc) => bloc.add(GotAllReadingsEvent()),
      verify: (_) {
        verify(() => readingService.getAll()).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );

    blocTest(
      'Test FindedReadingByBookTitleEvent work',
      build: () => readingsBloc,
      setUp: () {
        when(
          () => readingService.getReadingsByBookTitle(
            title: any(named: 'title'),
          ),
        ).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
      },
      act: (bloc) => bloc.add(
        FindedReadingByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(
          () => readingService.getReadingsByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsLoadedState>(),
      ],
    );

    blocTest(
      'Test FindedReadingByBookTitleEvent work when readings are empty',
      build: () => readingsBloc,
      setUp: () => when(
        () => readingService.getReadingsByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(
        FindedReadingByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(
          () => readingService.getReadingsByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsNotFoundState>(),
      ],
    );

    blocTest(
      'Test FindedReadingByBookTitleEvent work when reading id is empty',
      build: () => readingsBloc,
      setUp: () => when(
        () => readingService.getReadingsByBookTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => [
          ReadingModel(
            pagesReaded: 100,
            lastReadingDate: DateTime(2024, 03, 06),
            bookId: 'bookId',
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        FindedReadingByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(
          () => readingService.getReadingsByBookTitle(
            title: any(named: 'title'),
          ),
        ).called(1);
        verifyNever(() => bookService.getBookById(id: any(named: 'id')));
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );

    blocTest(
      'Test FindedReadingByBookTitleEvent work when throw LocalDatabaseException',
      build: () => readingsBloc,
      setUp: () {
        when(() => readingService.getReadingsByBookTitle(
            title: any(named: 'title'))).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
        FindedReadingByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(() => readingService.getReadingsByBookTitle(
            title: any(named: 'title'))).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );

    blocTest(
      'Test FindedReadingByBookTitleEvent work when throw Generic Exception',
      build: () => readingsBloc,
      setUp: () {
        when(() => readingService.getReadingsByBookTitle(
            title: any(named: 'title'))).thenAnswer(
          (_) async => [
            ReadingModel(
              id: 1,
              pagesReaded: 100,
              lastReadingDate: DateTime(2024, 03, 06),
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
        FindedReadingByBookTitleEvent(searchQueryName: 'searchQueryName'),
      ),
      verify: (_) {
        verify(() => readingService.getReadingsByBookTitle(
            title: any(named: 'title'))).called(1);
        verify(() => bookService.getBookById(id: any(named: 'id'))).called(1);
      },
      expect: () => [
        isA<ReadingsLoadingState>(),
        isA<ReadingsErrorState>(),
      ],
    );
  });
}
