import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/features/home/views/home_page.dart';
import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookBlocMock extends MockBloc<BookEvent, BookState> implements BookBloc {}

void main() {
  late BookBlocMock bookBloc;

  setUp(() {
    bookBloc = BookBlocMock();
  });

  group('Test Home Page Widgets', () {
    testWidgets('Test Home Page when is loading books', (tester) async {
      when(() => bookBloc.state).thenReturn(BooksLoadingState());

      await _initHomePage(tester, bookBloc);

      expect(
        find.byKey(const Key('BooksLoadingStateWidget')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('AnimatedSearchBar')),
        findsNothing,
      );
    });

    testWidgets('Test Home Page when is empty books', (tester) async {
      when(() => bookBloc.state).thenReturn(BookEmptyState());

      await _initHomePage(tester, bookBloc);

      expect(
        find.byKey(const Key('BookEmptyStateWidget')),
        findsOneWidget,
      );

      expect(
        find.text("Não foi encontrado nenhum livro com esses termos."),
        findsOne,
      );

      expect(
        find.byKey(const Key('AnimatedSearchBar')),
        findsNothing,
      );
    });

    testWidgets('Test Home Page when is loaded books', (tester) async {
      when(() => bookBloc.state).thenReturn(
        BooksLoadedState(
          books: [
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
              averageRating: 12.32,
              ratingsCount: 123,
            ),
          ],
        ),
      );

      await _initHomePage(tester, bookBloc);

      expect(
        find.byKey(const Key('BooksLoadedStateWidget')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('BooksGridView')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('AnimatedSearchBar')),
        findsOneWidget,
      );
    });

    testWidgets('Test Home Page when is throw error', (tester) async {
      when(() => bookBloc.state).thenReturn(
        BookErrorSate(errorMessage: 'errorMessage'),
      );

      await _initHomePage(tester, bookBloc);

      expect(
        find.byKey(const Key('BookErrorSateWidget')),
        findsOneWidget,
      );

      expect(find.text("errorMessage"), findsOne);

      expect(
        find.byKey(const Key('AnimatedSearchBar')),
        findsNothing,
      );
    });
  });

  group('Test search', () {
    testWidgets('Search', (tester) async {
      when(() => bookBloc.state).thenReturn(
        BooksLoadedState(
          books: [
            BookModel(
              id: 'id',
              title: 'Machado de Assis',
              authors: [AuthorModel.withEmptyName()],
              publisher: 'publisher',
              description: 'description',
              categories: [CategoryModel.withEmptyName()],
              pageCount: 320,
              imageUrl: 'imageUrl',
              buyLink: 'buyLink',
              averageRating: 12.32,
              ratingsCount: 123,
            ),
          ],
        ),
      );
      await _initHomePage(tester, bookBloc);

      await tester.pump(const Duration(seconds: 3));

      await tester.enterText(
        find.byKey(const Key('AnimatedSearchBar')),
        'Machado de Assis',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump(const Duration(seconds: 3));

      expect(
        find.byKey(const Key('BooksGridView')),
        findsOneWidget,
      );
    });
  });
}

Future<void> _initHomePage(
  WidgetTester tester,
  BookBloc bookBloc,
) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: bookBloc,
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
