import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/features/book_detail/bloc/book_detail_bloc.dart';
import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/book_detail/views/widgets/book_pages_reading_time/bloc/book_pages_reading_time_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class BookDetailBlocMock extends MockBloc<BookDetailEvent, BookDetailState>
    implements BookDetailBloc {}

class BookPagesReadingTimeBlocMock
    extends MockBloc<BookPagesReadingTimeEvent, BookPagesReadingTimeState>
    implements BookPagesReadingTimeBloc {}

void main() {
  late BookDetailBlocMock bookDetailBloc;
  late BookPagesReadingTimeBlocMock bookPagesReadingTimeBloc;

  final sampleBook = BookModel(
    id: 'test-book-id',
    title: 'Test Book Title',
    authors: [
      AuthorModel(name: 'Test Author 1'),
      AuthorModel(name: 'Test Author 2'),
    ],
    publisher: 'Test Publisher',
    description: 'This is a test book description for testing purposes.',
    categories: [
      CategoryModel(name: 'Fiction'),
      CategoryModel(name: 'Adventure'),
    ],
    pageCount: 320,
    imageUrl: 'https://example.com/test-book.jpg',
    buyLink: 'https://example.com/buy-test-book',
    averageRating: 4.5,
    ratingsCount: 150,
  );

  setUp(() {
    bookDetailBloc = BookDetailBlocMock();
    bookPagesReadingTimeBloc = BookPagesReadingTimeBlocMock();
  });

  group('Testing Initial State in BookDetailPage ||', () {
    testWidgets('testing initial loading state', (tester) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadingState(),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadingState(),
          BookDetailLoadedState(bookIsInserted: false),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      // Expecting find BookmarkIcon
      expect(
        find.byKey(const Key('BookmarkIcon')),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.bookmark_border),
        findsOneWidget,
      );

      // Expecting find BookTitle and AuthorName
      final authors = sampleBook.authors
          .map((author) => author.name)
          .toList()
          .join(', ');

      expect(
        find.byKey(const Key('TitleAndAuthorsText')),
        findsOneWidget,
      );
      expect(
        find.text(
          '${sampleBook.title} ― $authors',
        ),
        findsOneWidget,
      );

      //expecting find bookWidget
      expect(
        find.byKey(const Key('BookWidget')),
        findsOneWidget,
      );

      // expecting find ReadingTimeWidget and PagesCount
      expect(
        find.byKey(const Key('BookPagesText')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookPagesReadingTimeWidget')),
        findsOneWidget,
      );

      // Expecting find GoToStoreButton and InsertOrRemoveBookButton
      expect(
        find.byKey(const Key('GoToStoreButton')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.add),
        findsOneWidget,
      );
      expect(
        find.text('add-button'),
        findsOneWidget,
      );

      // expecting find BookDescription
      expect(
        find.byKey(const Key('SynopsisTitle')),
        findsOneWidget,
      );
      expect(
        find.text(sampleBook.description),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('RatingsTitle')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookRatingWidget')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookInformationTitle')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('PublisherDescriptionWidget')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('CategoriesDescriptionWidget')),
        findsOneWidget,
      );
    });

    testWidgets('testing loaded state with book already inserted', (
      tester,
    ) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadingState(),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadedState(bookIsInserted: true),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      await tester.pump();

      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );
      expect(
        find.text('remove-button'),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.bookmark),
        findsOneWidget,
      );
    });
  });

  group('Testing Book Insertion in BookDetailPage ||', () {
    testWidgets('testing render state when book inserted successfully', (
      tester,
    ) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadingState(),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadedState(bookIsInserted: false),
          BookDetailLoadingState(),
          BookDetailLoadedState(bookIsInserted: true),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      await tester.tap(find.byKey(const Key('InsertOrRemoveBookButton')));
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.widgetWithText(
          SnackBar,
          'book-successfully-added-snackbar',
        ),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.bookmark),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.remove),
        findsOneWidget,
      );
    });

    testWidgets('testing render state when insert fails', (tester) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadingState(),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadedState(bookIsInserted: false),
          BookDetailLoadingState(),
          BookDetailErrorState(
            errorMessage: 'Error on inserting the book in database',
          ),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      await tester.tap(find.byKey(const Key('InsertOrRemoveBookButton')));
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.widgetWithText(
          SnackBar,
          'Error on inserting the book in database',
        ),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.bookmark_border),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.add),
        findsOneWidget,
      );
    });
  });

  group('Testing Book Removal in BookDetailPage ||', () {
    testWidgets('testing render state when book removed successfully', (
      tester,
    ) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadedState(bookIsInserted: true),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadedState(bookIsInserted: true),
          BookDetailLoadingState(),
          BookDetailLoadedState(bookIsInserted: false),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      await tester.tap(find.byKey(const Key('InsertOrRemoveBookButton')));
      await tester.pump();

      expect(
        find.widgetWithText(
          SnackBar,
          'book-successfully-removed-snackbar',
        ),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.bookmark_border),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.add),
        findsOneWidget,
      );
    });

    testWidgets('testing render state when removal fails', (tester) async {
      when(() => bookDetailBloc.state).thenReturn(
        BookDetailLoadedState(bookIsInserted: true),
      );
      when(() => bookPagesReadingTimeBloc.state).thenReturn(
        BookPagesReadingTimeLoadingState(),
      );

      whenListen(
        bookDetailBloc,
        Stream.fromIterable([
          BookDetailLoadedState(bookIsInserted: true),
          BookDetailLoadingState(),
          BookDetailErrorState(
            errorMessage: 'Error on removing the book from database',
          ),
        ]),
      );

      await _initBookDetailPage(
        tester,
        bookDetailBloc,
        sampleBook,
        bookPagesReadingTimeBloc,
      );

      await tester.tap(find.byKey(const Key('InsertOrRemoveBookButton')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('ConfirmDialogButton')));
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.widgetWithText(
          SnackBar,
          'Error on removing the book from database',
        ),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.bookmark),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('InsertOrRemoveBookButton')),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.remove),
        findsOneWidget,
      );
    });
  });
}

Future<void> _initBookDetailPage(
  WidgetTester tester,
  BookDetailBloc bookDetailBloc,
  BookModel bookModel,
  BookPagesReadingTimeBloc bookPagesReadingTimeBloc,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        BlocProvider<BookDetailBloc>.value(
          value: bookDetailBloc,
        ),
        BlocProvider<BookPagesReadingTimeBloc>.value(
          value: bookPagesReadingTimeBloc,
        ),
      ],
      child: MaterialApp(
        home: BookDetailPage(
          bookModel: bookModel,
        ),
      ),
    ),
  );
}
