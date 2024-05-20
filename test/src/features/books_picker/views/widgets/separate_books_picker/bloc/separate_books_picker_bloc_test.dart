import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/books_picker/views/widgets/separate_books_picker/bloc/separate_books_picker_bloc.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookServiceMock extends Mock implements BookService {}

void main() {
  final bookService = BookServiceMock();
  late SeparateBooksPickerBloc bloc;

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
      status: BookStatus.library,
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
      status: BookStatus.library,
    ),
  ];

  setUp(
    () => bloc = SeparateBooksPickerBloc(bookService),
  );

  group('Test SeparatedBooksPickerBloc ||', () {
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
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerLoadedState>(),
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
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work with empty bookService',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work with empty book',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenAnswer(
        (_) async => [booksModel.first.copyWith(status: BookStatus.loaned)],
      ),
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerEmptyState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work when throw LocalDatabaseException',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenThrow(const LocalDatabaseException('Error on Database')),
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerErrorState>(),
      ],
    );

    blocTest(
      'Test if GotAllBooksEvent work when throw Generic Exception',
      build: () => bloc,
      setUp: () => when(
        () => bookService.getAllBook(),
      ).thenThrow(Exception('Generic Exception')),
      act: (bloc) => bloc.add(GotAllSeparatedBooksPickerEvent()),
      verify: (_) => verify(() => bookService.getAllBook()).called(1),
      expect: () => [
        isA<SeparateBooksPickerLoadingState>(),
        isA<SeparateBooksPickerErrorState>(),
      ],
    );
  });
}
