import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/dtos/bookcase_dto.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/features/bookcase/views/bookcase_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseBlocMock extends MockBloc<BookcaseEvent, BookcaseState>
    implements BookcaseBloc {}

void main() {
  late BookcaseBlocMock bookcaseBloc;

  const bookcasesDto = [
    BookcaseDto(
      bookcase: BookcaseModel(
        id: 1,
        name: 'Bookcase 1',
        description: 'Description of Bookcase 1',
        color: Colors.red,
      ),
    ),
    BookcaseDto(
      bookcase: BookcaseModel(
        id: 2,
        name: 'Bookcase 2',
        color: Colors.blue,
      ),
    ),
  ];

  setUp(() {
    bookcaseBloc = BookcaseBlocMock();
  });

  group('Tests Initial Bookcase States in BookcasePage', () {
    testWidgets(
      'Test find loading circle when the bookcase bloc is loading',
      (tester) async {
        when(() => bookcaseBloc.state).thenReturn(BookcaseLoadingState());

        await _initBookcasePage(tester, bookcaseBloc);

        expect(
          find.byKey(const Key('BookcaseLoadingState')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Test find empty Bookcase Widget when not found any bookcase',
      (tester) async {
        when(() => bookcaseBloc.state).thenReturn(BookcaseEmptyState());

        await _initBookcasePage(tester, bookcaseBloc);

        expect(
          find.byKey(const Key('BookcaseEmptyState')),
          findsOneWidget,
        );

        expect(
          find.text('create-new-bookcase-button'),
          findsOne,
        );
      },
    );

    testWidgets(
      'Test find Not Found Bookcase State Widget when not found bookcases',
      (tester) async {
        when(() => bookcaseBloc.state).thenReturn(
          BookcaseNotFoundState(),
        );

        await _initBookcasePage(tester, bookcaseBloc);

        expect(
          find.byKey(const Key('BookcaseNotFoundStateWidget')),
          findsOneWidget,
        );

        expect(
          find.text('bookcase-not-found-whit-this-terms'),
          findsOne,
        );
      },
    );

    testWidgets(
      'Test find Bookcase Error state Widget when Bloc emit Error',
      (tester) async {
        when(() => bookcaseBloc.state).thenReturn(
          BookcaseErrorState(errorMessage: 'Error message'),
        );

        await _initBookcasePage(tester, bookcaseBloc);

        expect(
          find.byKey(const Key('BookcaseErrorStateWidget')),
          findsOneWidget,
        );

        expect(
          find.text('Error message'),
          findsOne,
        );
      },
    );

    testWidgets(
      'Test find Bookcase Loaded State Widget when found bookcases',
      (tester) async {
        when(() => bookcaseBloc.state).thenReturn(
          BookcaseLoadedState(
            bookcasesDto: bookcasesDto,
          ),
        );

        await _initBookcasePage(tester, bookcaseBloc);

        expect(
          find.byKey(const Key('BookcaseLoadedState')),
          findsOneWidget,
        );
      },
    );
  });

  group('Test Action in Bookcase States in BookcasePage', () {
    testWidgets('test when remove books on bookcase', (tester) async {
      when(() => bookcaseBloc.state).thenReturn(
        BookcaseLoadedState(
          bookcasesDto: bookcasesDto,
        ),
      );

      await _initBookcasePage(tester, bookcaseBloc);

      expect(
        find.byKey(const Key('BookcaseWidget')),
        findsWidgets,
      );

      await tester.longPress(
        find.byKey(const Key('BookcaseWidget')).first,
      );

      expect(
        find.byKey(const Key('SelectedBookcaseWidget')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const Key('DeleteSelectedItemsButton')),
      );

      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('BookcaseLoadedState')),
        findsOneWidget,
      );
    });

    testWidgets('Test when search Bookcase', (tester) async {
      const searchQuery = 'Bookcase 1';

      when(() => bookcaseBloc.state).thenReturn(
        BookcaseLoadedState(
          bookcasesDto: bookcasesDto,
        ),
      );

      await _initBookcasePage(tester, bookcaseBloc, searchQuery);

      expect(
        find.byKey(const Key('BookcaseLoadedState')),
        findsOneWidget,
      );
    });
  });
}

Future<void> _initBookcasePage(
  WidgetTester tester,
  BookcaseBloc bookcaseBloc, [
  String? searchQuery,
]) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: bookcaseBloc,
      child: MaterialApp(
        home: BookcasePage(searchQuery: searchQuery),
      ),
    ),
  );
}
