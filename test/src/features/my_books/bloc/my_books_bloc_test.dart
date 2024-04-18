import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/my_books/bloc/my_books_bloc.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

void main() {
  final bookService = BookServiceMock();
  late MyBooksBloc bloc;

  final booksModel = [
    BookModel(
      id: 'id',
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
      id: 'id2',
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
  ];

  setUp(
    () => bloc = MyBooksBloc(bookService),
  );

  group('Test MyBooksBloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test if GotAllBooksEvent work',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenAnswer(
        (_) async => booksModel,
      ),
      act: (bloc) => bloc.add(GotAllBooksEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksLoadedState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work with empty state',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(GotAllBooksEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenThrow(LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(GotAllBooksEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksErrorState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(GotAllBooksEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksErrorState>(),
      ],
    );

    blocTest(
      'Test if SearchedEvent work',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => booksModel,
      ),
      act: (bloc) => bloc.add(
        SearchedBooksEvent(searchQuery: 'title'),
      ),
      verify: (_) => verify(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksLoadedState>(),
      ],
    );

    blocTest(
      'Test if SearchedEvent work with not found state',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(
        SearchedBooksEvent(searchQuery: 'title'),
      ),
      verify: (_) => verify(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksNotFoundState>(),
      ],
    );

    blocTest(
      'Test if SearchedEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).thenThrow(LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(
        SearchedBooksEvent(searchQuery: 'title'),
      ),
      verify: (_) => verify(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksErrorState>(),
      ],
    );

    blocTest(
      'Test if SearchedEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(
        SearchedBooksEvent(searchQuery: 'title'),
      ),
      verify: (_) => verify(
        () => bookService.getBooksByTitle(
          title: any(named: 'title'),
        ),
      ).called(1),
      expect: () => [
        isA<MyBooksLoadingState>(),
        isA<MyBooksErrorState>(),
      ],
    );
  });
}
