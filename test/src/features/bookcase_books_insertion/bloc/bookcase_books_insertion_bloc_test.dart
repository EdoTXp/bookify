import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/bookcase_books_insertion/bloc/bookcase_books_insertion_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseServiceMock extends Mock implements BookcaseService {}

class BookServiceMock extends Mock implements BookService {}

void main() {
  final bookService = BookServiceMock();
  final bookcaseService = BookcaseServiceMock();

  late BookcaseBooksInsertionBloc bloc;

  setUp(
    () => bloc = BookcaseBooksInsertionBloc(
      bookService,
      bookcaseService,
    ),
  );

  tearDownAll(() => bloc.close());

  final booksModel = [
    BookModel(
      id: '1',
      title: 'title',
      authors: [AuthorModel.withEmptyName()],
      publisher: 'publisher',
      description: 'description',
      categories: [CategoryModel.withEmptyName()],
      pageCount: 320,
      imageUrl: 'imageUrl',
      buyLink: 'buyLink',
      averageRating: 4.5,
      ratingsCount: 720,
    ),
    BookModel(
      id: '2',
      title: 'title',
      authors: [AuthorModel.withEmptyName()],
      publisher: 'publisher',
      description: 'description',
      categories: [CategoryModel.withEmptyName()],
      pageCount: 320,
      imageUrl: 'imageUrl',
      buyLink: 'buyLink',
      averageRating: 4.5,
      ratingsCount: 720,
    )
  ];

  final bookRelationShip = [
    {
      'bookcaseId': 1,
      'bookId': '1',
    },
  ];

  group('Test BookcaseBooksInsertionBloc bloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test if GotAllBooksForThisBookcaseEvent work',
      build: () => bloc,
      setUp: () {
        when(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).thenAnswer(
          (_) async => bookRelationShip,
        );

        when(
          () => bookService.getAllBook(),
        ).thenAnswer(
          (_) async => booksModel,
        );
      },
      act: (bloc) => bloc.add(GotAllBooksForThisBookcaseEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getAllBook()).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
      },
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionLoadedState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksForThisBookcaseEvent work when all books is empty',
      build: () => bloc,
      setUp: () {
        when(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).thenAnswer(
          (_) async => bookRelationShip,
        );

        when(
          () => bookService.getAllBook(),
        ).thenAnswer(
          (_) async => [],
        );
      },
      act: (bloc) => bloc.add(GotAllBooksForThisBookcaseEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getAllBook()).called(1);
        verifyNever(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId')));
      },
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksForThisBookcaseEvent work when have all relationships',
      build: () => bloc,
      setUp: () {
        when(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).thenAnswer(
          (_) async => [
            ...bookRelationShip,
            {
              'bookcaseId': 1,
              'bookId': '2',
            }
          ],
        );

        when(
          () => bookService.getAllBook(),
        ).thenAnswer(
          (_) async => booksModel,
        );
      },
      act: (bloc) => bloc.add(GotAllBooksForThisBookcaseEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getAllBook()).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).called(1);
      },
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksForThisBookcaseEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () {
        when(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).thenAnswer(
          (_) async => [
            ...bookRelationShip,
            {
              'bookcaseId': 1,
              'bookId': '2',
            }
          ],
        );

        when(
          () => bookService.getAllBook(),
        ).thenThrow(const LocalDatabaseException('Error on Database'));
      },
      act: (bloc) => bloc.add(GotAllBooksForThisBookcaseEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getAllBook()).called(1);
        verifyNever(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId')));
      },
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksForThisBookcaseEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () {
        when(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        ).thenAnswer(
          (_) async => [
            ...bookRelationShip,
            {
              'bookcaseId': 1,
              'bookId': '2',
            }
          ],
        );

        when(
          () => bookService.getAllBook(),
        ).thenThrow(Exception('Generic Exception'));
      },
      act: (bloc) => bloc.add(GotAllBooksForThisBookcaseEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getAllBook()).called(1);
        verifyNever(
          () => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'),
          ),
        );
      },
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test if InsertBooksOnBookcaseEvent work',
      build: () => bloc,
      setUp: () => when(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer(
        (invocation) async => 1,
      ),
      act: (bloc) => bloc.add(InsertBooksOnBookcaseEvent(
        bookcaseId: 2,
        books: [
          BookModel(
            id: '1',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          ),
          BookModel(
            id: '2',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          )
        ],
      )),
      verify: (_) => verify(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).called(2),
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionInsertedState>(),
      ],
    );

    blocTest(
      'Test if InsertBooksOnBookcaseEvent with error on insertion work',
      build: () => bloc,
      setUp: () => when(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(InsertBooksOnBookcaseEvent(
        bookcaseId: 2,
        books: [
          BookModel(
            id: '1',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          ),
          BookModel(
            id: '2',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          )
        ],
      )),
      verify: (_) => verify(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test if InsertBooksOnBookcaseEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () => when(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenThrow(const LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(InsertBooksOnBookcaseEvent(
        bookcaseId: 2,
        books: [
          BookModel(
            id: '1',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          ),
          BookModel(
            id: '2',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          )
        ],
      )),
      verify: (_) => verify(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionErrorState>(),
      ],
    );

    blocTest(
      'Test if InsertBooksOnBookcaseEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () => when(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(InsertBooksOnBookcaseEvent(
        bookcaseId: 2,
        books: [
          BookModel(
            id: '1',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          ),
          BookModel(
            id: '2',
            title: 'title',
            authors: [AuthorModel.withEmptyName()],
            publisher: 'publisher',
            description: 'description',
            categories: [CategoryModel.withEmptyName()],
            pageCount: 320,
            imageUrl: 'imageUrl',
            buyLink: 'buyLink',
            averageRating: 4.5,
            ratingsCount: 720,
          )
        ],
      )),
      verify: (_) => verify(
        () => bookcaseService.insertBookcaseRelationship(
          bookcaseId: any(named: 'bookcaseId'),
          bookId: any(named: 'bookId'),
        ),
      ).called(1),
      expect: () => [
        isA<BookcaseBooksInsertionLoadingState>(),
        isA<BookcaseBooksInsertionErrorState>(),
      ],
    );
  });
}
