import 'package:bookify/src/book/errors/book_error.dart';
import 'package:bookify/src/book/bloc/book_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/books_model_mock.dart';
import '../../mocks/google_book_service_mock.dart';

void main() {
  group('Test every event of Book Bloc: ', () {
    late BookBloc bookBloc;
    late GoogleBookServiceMock service;

    final booksMock = booksModelMock;

    setUp((() {
      service = GoogleBookServiceMock();
      bookBloc = BookBloc(service);
    }));

    blocTest(
      '1- Test if initial state is empty',
      build: () => bookBloc,
      verify: (_) {
        verifyZeroInteractions(service);
      },
      expect: () => [],
    );

    blocTest<BookBloc, BookState>(
      '2- Test if the GetAllBooksEvent is not empty state',
      build: () => bookBloc,
      setUp: () => when((() => service.getAllBooks()))
          .thenAnswer((_) async => booksMock),
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => service.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '3- Test if the GetAllBooksEvent is empty state',
      setUp: () =>
          when((() => service.getAllBooks())).thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => service.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '4- Test if the GetAllBooksEvent is a error state',
      setUp: () => when((() => service.getAllBooks()))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(GetAllBooksEvent()),
      verify: (_) {
        verify(() => service.getAllBooks()).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '5- Test if the FindBookByIsbnEvent is not empty state',
      setUp: () => when((() => service.findBookByISBN(isbn: 11111)))
          .thenAnswer((_) async => booksMock.first),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBookByIsbnEvent(isbn: 11111)),
      verify: (_) {
        verify(() => service.findBookByISBN(isbn: 11111)).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<SingleBookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '6- Test if the FindBookByIsbnEvent is a error state',
      setUp: () => when((() => service.findBookByISBN(isbn: 11111)))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBookByIsbnEvent(isbn: 11111)),
      verify: (_) {
        verify(() => service.findBookByISBN(isbn: 11111)).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '7- Test if the FindBooksByAuthorEvent is not empty state',
      setUp: () => when((() => service.findBooksByAuthor(author: 'author')))
          .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => service.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '8- Test if the FindBooksByAuthorEvent is empty state',
      setUp: () => when((() => service.findBooksByAuthor(author: 'author')))
          .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => service.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '9- Test if the FindBooksByAuthorEvent is a error state',
      setUp: () => when((() => service.findBooksByAuthor(author: 'author')))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByAuthorEvent(author: 'author')),
      verify: (_) {
        verify(() => service.findBooksByAuthor(author: 'author')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '10- Test if the FindBooksByCategoryEvent is not empty state',
      setUp: () =>
          when((() => service.findBooksByCategory(category: 'category')))
              .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => service.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '11- Test if the FindBooksByCategoryEvent is empty state',
      setUp: () =>
          when((() => service.findBooksByCategory(category: 'category')))
              .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => service.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '12- Test if the FindBooksByCategoryEvent is a error state',
      setUp: () =>
          when((() => service.findBooksByCategory(category: 'category')))
              .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByCategoryEvent(category: 'category')),
      verify: (_) {
        verify(() => service.findBooksByCategory(category: 'category'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '13- Test if the FindBooksByPublisherEvent is not empty state',
      setUp: () =>
          when((() => service.findBooksByPublisher(publisher: 'publisher')))
              .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => service.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '14- Test if the FindBooksByPublisherEvent is empty state',
      setUp: () =>
          when((() => service.findBooksByPublisher(publisher: 'publisher')))
              .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => service.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '15- Test if the FindBooksByPublisherEvent is a error state',
      setUp: () =>
          when((() => service.findBooksByPublisher(publisher: 'publisher')))
              .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) =>
          bloc.add(FindBooksByPublisherEvent(publisher: 'publisher')),
      verify: (_) {
        verify(() => service.findBooksByPublisher(publisher: 'publisher'))
            .called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '16- Test if the FindBooksByTitleEvent is not empty state',
      setUp: () => when((() => service.findBooksByTitle(title: 'title')))
          .thenAnswer((_) async => booksMock),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => service.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookLoadedState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '17- Test if the FindBooksByTitleEvent is empty state',
      setUp: () => when((() => service.findBooksByTitle(title: 'title')))
          .thenAnswer((_) async => []),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => service.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookEmptyState>(),
      ],
    );

    blocTest<BookBloc, BookState>(
      '18- Test if the FindBooksByTitleEvent is a error state',
      setUp: () => when((() => service.findBooksByTitle(title: 'title')))
          .thenThrow(BookException('this is a error')),
      build: () => bookBloc,
      act: (bloc) => bloc.add(FindBooksByTitleEvent(title: 'title')),
      verify: (_) {
        verify(() => service.findBooksByTitle(title: 'title')).called(1);
      },
      expect: () => [
        isA<BookLoadingState>(),
        isA<BookErrorSate>(),
      ],
    );
  });
}