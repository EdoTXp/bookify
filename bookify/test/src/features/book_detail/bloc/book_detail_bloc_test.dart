import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/book_detail/bloc/book_detail_bloc.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

void main() {
  late BookServiceMock bookService;
  late BookDetailBloc bookDetailBloc;

  final bookModel = BookModel(
    id: '1',
    title: 'title',
    authors: [AuthorModel(name: 'name')],
    publisher: 'publisher',
    description: 'description',
    categories: [CategoryModel(name: 'name')],
    pageCount: 320,
    imageUrl: 'imageUrl',
    buyLink: 'buyLink',
    averageRating: 3.4,
    ratingsCount: 200,
  );

  setUp(() {
    bookService = BookServiceMock();
    bookDetailBloc = BookDetailBloc(bookService);
  });

  group('Test BookDetailBloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bookDetailBloc,
      verify: (_) => bookDetailBloc.dispose(),
      expect: () => [],
    );

    blocTest(
      'test if VerifiedBookIsInsertedEvent work',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.verifyBookIsAlreadyInserted(id: any(named: 'id')),
      ).thenAnswer((_) async => true),
      act: (bloc) => bloc.add(VerifiedBookIsInsertedEvent(bookId: '1')),
      verify: (_) {
        verify(() => bookService.verifyBookIsAlreadyInserted(id: '1'))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailLoadedState>(),
      ],
    );

    blocTest(
      'test if VerifiedBookIsInsertedEvent work with error state',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.verifyBookIsAlreadyInserted(id: any(named: 'id')),
      ).thenThrow(LocalDatabaseException('error on database')),
      act: (bloc) => bloc.add(VerifiedBookIsInsertedEvent(bookId: '1')),
      verify: (_) {
        verify(() => bookService.verifyBookIsAlreadyInserted(id: '1'))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if VerifiedBookIsInsertedEvent work with error state on generic exception',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.verifyBookIsAlreadyInserted(id: any(named: 'id')),
      ).thenThrow(Exception('generic exception')),
      act: (bloc) => bloc.add(VerifiedBookIsInsertedEvent(bookId: '1')),
      verify: (_) {
        verify(() => bookService.verifyBookIsAlreadyInserted(id: '1'))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookInsertedEvent work',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.insertCompleteBook(bookModel: bookModel),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(BookInsertedEvent(bookModel: bookModel)),
      verify: (_) {
        verify(() => bookService.insertCompleteBook(bookModel: bookModel))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailLoadedState>(),
      ],
    );

    blocTest(
      'test if BookInsertedEvent work with error on insert',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.insertCompleteBook(bookModel: bookModel),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(BookInsertedEvent(bookModel: bookModel)),
      verify: (_) {
        verify(() => bookService.insertCompleteBook(bookModel: bookModel))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookInsertedEvent work with error state',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.insertCompleteBook(bookModel: bookModel),
      ).thenThrow(LocalDatabaseException('error on database')),
      act: (bloc) => bloc.add(BookInsertedEvent(bookModel: bookModel)),
      verify: (_) {
        verify(() => bookService.insertCompleteBook(bookModel: bookModel))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookInsertedEvent work with error state on generic exception',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.insertCompleteBook(bookModel: bookModel),
      ).thenThrow(Exception('generic exception')),
      act: (bloc) => bloc.add(BookInsertedEvent(bookModel: bookModel)),
      verify: (_) {
        verify(() => bookService.insertCompleteBook(bookModel: bookModel))
            .called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookRemovedEvent work',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.deleteBook(id: '1'),
      ).thenAnswer((_) async => 1),
      act: (bloc) => bloc.add(BookRemovedEvent(bookId: bookModel.id)),
      verify: (_) {
        verify(() => bookService.deleteBook(id: '1')).called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailLoadedState>(),
      ],
    );

    blocTest(
      'test if BookRemovedEvent work with error on delete',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.deleteBook(id: '1'),
      ).thenAnswer((_) async => 0),
      act: (bloc) => bloc.add(BookRemovedEvent(bookId: bookModel.id)),
      verify: (_) {
        verify(() => bookService.deleteBook(id: '1')).called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookRemovedEvent work with error state',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.deleteBook(id: '1'),
      ).thenThrow(LocalDatabaseException('error on database')),
      act: (bloc) => bloc.add(BookRemovedEvent(bookId: bookModel.id)),
      verify: (_) {
        verify(() => bookService.deleteBook(id: '1')).called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );

    blocTest(
      'test if BookRemovedEvent work with error state on generic exception',
      build: () => bookDetailBloc,
      setUp: () => when(
        () => bookService.deleteBook(id: '1'),
      ).thenThrow(Exception('generic exception')),
      act: (bloc) => bloc.add(BookRemovedEvent(bookId: bookModel.id)),
      verify: (_) {
        verify(() => bookService.deleteBook(id: '1')).called(1);
      },
      expect: () => [
        isA<BookDetailLoadingState>(),
        isA<BookDetailErrorState>(),
      ],
    );
  });
}
