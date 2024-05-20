import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/books_picker/views/widgets/book_on_bookcase_picker/bloc/book_on_bookcase_picker_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

class BookcaseServiceMock extends Mock implements BookcaseService {}

void main() {
  final bookService = BookServiceMock();
  final bookcaseService = BookcaseServiceMock();
  late BookOnBookcasePickerBloc bloc;

  final bookModel = BookModel(
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
    status: BookStatus.library,
  );

  setUp(() {
    bloc = BookOnBookcasePickerBloc(
      bookService,
      bookcaseService,
    );
  });

  group('Test bookOnBookcasePickerBloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => bloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'test if GotAllBookOnBookcasePickerEvent work',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenAnswer((_) async => bookModel);

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotAllBookOnBookcasePickerEvent(bookcaseId: 1)),
      verify: (bloc) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookOnBookcasePickerLoadingState>(),
        isA<BookOnBookcasePickerLoadedState>(),
      ],
    );

    blocTest(
      'test if GotAllBookOnBookcasePickerEvent work with empty relationship',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenAnswer((_) async => bookModel);

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [],
        );
      },
      act: (bloc) => bloc.add(GotAllBookOnBookcasePickerEvent(bookcaseId: 1)),
      verify: (_) {
        verifyNever(() => bookService.getBookById(id: 'id'));
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookOnBookcasePickerLoadingState>(),
        isA<BookOnBookcasePickerEmptyState>(),
      ],
    );

    blocTest(
      'test if GotAllBookOnBookcasePickerEvent work when books is empty',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenAnswer(
            (_) async => bookModel.copyWith(status: BookStatus.loaned));

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [],
        );
      },
      act: (bloc) => bloc.add(GotAllBookOnBookcasePickerEvent(bookcaseId: 1)),
      verify: (_) {
        verifyNever(() => bookService.getBookById(id: 'id'));
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookOnBookcasePickerLoadingState>(),
        isA<BookOnBookcasePickerEmptyState>(),
      ],
    );

    blocTest(
      'test if GotAllBookOnBookcasePickerEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenThrow(const LocalDatabaseException('Error on database'));

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotAllBookOnBookcasePickerEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookOnBookcasePickerLoadingState>(),
        isA<BookOnBookcasePickerErrorState>(),
      ],
    );

    blocTest(
      'test if GotAllBookOnBookcasePickerEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () {
        when(
          () => bookService.getBookById(id: any(named: 'id')),
        ).thenThrow(Exception('Generic Error'));

        when(() => bookcaseService.getAllBookcaseRelationships(
            bookcaseId: any(named: 'bookcaseId'))).thenAnswer(
          (_) async => [
            {'bookcaseId': 1, 'bookId': 'id'},
          ],
        );
      },
      act: (bloc) => bloc.add(GotAllBookOnBookcasePickerEvent(bookcaseId: 1)),
      verify: (_) {
        verify(() => bookService.getBookById(id: 'id')).called(1);
        verify(() => bookcaseService.getAllBookcaseRelationships(bookcaseId: 1))
            .called(1);
      },
      expect: () => [
        isA<BookOnBookcasePickerLoadingState>(),
        isA<BookOnBookcasePickerErrorState>(),
      ],
    );
  });
}
