
import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/errors/book_error/book_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/books_model_mock.dart';
import '../../../mocks/google_book_repository_mock.dart';

void main() {
  group('Test every event of Book Bloc: ', () {
    late BookBloc bookBloc;
    late GoogleBookRepositoryMock repository;

    final booksMock = booksModelMock;

    setUp((() {
      repository = GoogleBookRepositoryMock();
      bookBloc = BookBloc(repository);
    }));

    blocTest(
      '1- Test if initial state is empty',
      build: () => bookBloc,
      verify: (_) => bookBloc.close(),
      expect: () => [],
    );

    blocTest<BookBloc, BookState>(
      '2- Test if the GetAllBooksEvent is not empty state',
      build: () => bookBloc,
      setUp: () => when((() => repository.getAllBooks()))
          .thenAnswer((_) async => booksMock),
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => repository.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BooksLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '3- Test if the GetAllBooksEvent is empty state',
      setUp: () =>
          when((() => repository.getAllBooks())).thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => repository.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '4- Test if the GetAllBooksEvent is a error state',
      setUp: () => when((() => repository.getAllBooks()))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => repository.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '5- Test if the FindBookByIsbnEvent is not empty state',
      setUp: () => when((() => repository.findBookByISBN(isbn: 11111)))
          .thenAnswer((_) async => booksMock.first),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBookByIsbnEvent(isbn: 11111)),
      verify: (_) {
        verify(() => repository.findBookByISBN(isbn: 11111)).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<SingleBookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '6- Test if the FindBookByIsbnEvent is a error state',
      setUp: () => when((() => repository.findBookByISBN(isbn: 11111)))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBookByIsbnEvent(isbn: 11111)),
      verify: (_) {
        verify(() => repository.findBookByISBN(isbn: 11111)).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '7- Test if the FindBooksByAuthorEvent is not empty state',
      setUp: () => when((() => repository.findBooksByAuthor(author: 'author')))
          .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => repository.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BooksLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '8- Test if the FindBooksByAuthorEvent is empty state',
      setUp: () => when((() => repository.findBooksByAuthor(author: 'author')))
          .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => repository.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '9- Test if the FindBooksByAuthorEvent is a error state',
      setUp: () => when((() => repository.findBooksByAuthor(author: 'author')))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => repository.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '10- Test if the FindBooksByCategoryEvent is not empty state',
      setUp: () =>
          when((() => repository.findBooksByCategory(category: 'category')))
              .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => repository.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BooksLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '11- Test if the FindBooksByCategoryEvent is empty state',
      setUp: () =>
          when((() => repository.findBooksByCategory(category: 'category')))
              .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => repository.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '12- Test if the FindBooksByCategoryEvent is a error state',
      setUp: () =>
          when((() => repository.findBooksByCategory(category: 'category')))
              .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => repository.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '13- Test if the FindBooksByPublisherEvent is not empty state',
      setUp: () =>
          when((() => repository.findBooksByPublisher(publisher: 'publisher')))
              .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => repository.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BooksLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '14- Test if the FindBooksByPublisherEvent is empty state',
      setUp: () =>
          when((() => repository.findBooksByPublisher(publisher: 'publisher')))
              .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => repository.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '15- Test if the FindBooksByPublisherEvent is a error state',
      setUp: () =>
          when((() => repository.findBooksByPublisher(publisher: 'publisher')))
              .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => repository.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '16- Test if the FindBooksByTitleEvent is not empty state',
      setUp: () => when((() => repository.findBooksByTitle(title: 'title')))
          .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => repository.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BooksLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '17- Test if the FindBooksByTitleEvent is empty state',
      setUp: () => when((() => repository.findBooksByTitle(title: 'title')))
          .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => repository.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '18- Test if the FindBooksByTitleEvent is a error state',
      setUp: () => when((() => repository.findBooksByTitle(title: 'title')))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => repository.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BooksLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );
  });
}
