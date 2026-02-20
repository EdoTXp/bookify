import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/features/bookcase_insertion/bloc/bookcase_insertion_bloc.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BookcaseInsertionBlocMock
    extends MockBloc<BookcaseInsertionEvent, BookcaseInsertionState>
    implements BookcaseInsertionBloc {}

void main() {
  late BookcaseInsertionBlocMock bookcaseInsertionBloc;

  setUp(() {
    bookcaseInsertionBloc = BookcaseInsertionBlocMock();
  });
  group('Testing insertion Bookcase in BookcaseInsertionPage ||', () {
    testWidgets('testing initial State', (tester) async {
      when(() => bookcaseInsertionBloc.state).thenReturn(
        BookcaseInsertionLoadingState(),
      );

      await _initBookcaseInsertionPage(
        tester,
        bookcaseInsertionBloc,
      );

      expect(
        find.text('create-bookcase-title'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ClearAllFieldsButton')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookcaseNameTextFormField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookcaseDescriptionTextFormField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('BookcaseColorTextFormField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ConfirmBookcaseInsertionButton')),
        findsOneWidget,
      );
    });

    testWidgets('testing successful insertion', (tester) async {
      when(() => bookcaseInsertionBloc.state).thenReturn(
        BookcaseInsertionLoadingState(),
      );

      whenListen(
        bookcaseInsertionBloc,
        Stream.fromIterable([
          BookcaseInsertionInsertedState(
            bookcaseInsertionMessage: 'Bookcase inserted successfully',
          ),
        ]),
      );

      await _initBookcaseInsertionPage(tester, bookcaseInsertionBloc);

      await tester.enterText(
        find.byKey(const Key('BookcaseNameTextFormField')),
        'Bookcase 1',
      );
      await tester.enterText(
        find.byKey(const Key('BookcaseDescriptionTextFormField')),
        'My personal bookcase',
      );

      await tester.tap(find.byKey(const Key('ConfirmBookcaseInsertionButton')));
      await tester.pump();

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Bookcase inserted successfully'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(BookcaseInsertionPage), findsNothing);
    });

    testWidgets('testing validation: name field cannot be empty', (
      tester,
    ) async {
      when(
        () => bookcaseInsertionBloc.state,
      ).thenReturn(BookcaseInsertionLoadingState());

      await _initBookcaseInsertionPage(tester, bookcaseInsertionBloc);

      await tester.tap(find.byKey(const Key('ConfirmBookcaseInsertionButton')));
      await tester.pump();

      expect(find.text('field-cannot-be-empty-error'), findsOneWidget);
    });

    testWidgets('testing failure insertion', (tester) async {
      when(
        () => bookcaseInsertionBloc.state,
      ).thenReturn(BookcaseInsertionLoadingState());

      whenListen(
        bookcaseInsertionBloc,
        Stream.fromIterable([
          BookcaseInsertionErrorState(errorMessage: 'Database Error'),
        ]),
      );

      await _initBookcaseInsertionPage(tester, bookcaseInsertionBloc);

      await tester.enterText(
        find.byKey(const Key('BookcaseNameTextFormField')),
        'Error Test',
      );
      await tester.tap(find.byKey(const Key('ConfirmBookcaseInsertionButton')));

      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Database Error'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(BookcaseInsertionPage), findsNothing);
    });
  });

  group('Testing update Bookcase in BookcaseInsertionPage ||', () {
    final existingBookcase = BookcaseModel(
      id: 1,
      name: 'Old Bookcase',
      description: 'Old Description',
      color: Colors.blue,
    );

    testWidgets('testing initial State in update mode', (tester) async {
      when(
        () => bookcaseInsertionBloc.state,
      ).thenReturn(BookcaseInsertionLoadingState());

      await _initBookcaseInsertionPage(
        tester,
        bookcaseInsertionBloc,
        existingBookcase,
      );

      expect(find.text('edit-bookcase-title'), findsOneWidget);
      expect(find.text('Old Bookcase'), findsOneWidget);
      expect(find.text('Old Description'), findsOneWidget);
    });

    testWidgets('testing successful update', (tester) async {
      when(
        () => bookcaseInsertionBloc.state,
      ).thenReturn(BookcaseInsertionLoadingState());

      whenListen(
        bookcaseInsertionBloc,
        Stream.fromIterable([
          BookcaseInsertionInsertedState(
            bookcaseInsertionMessage: 'Updated successfully',
          ),
        ]),
      );

      await _initBookcaseInsertionPage(
        tester,
        bookcaseInsertionBloc,
        existingBookcase,
      );

      await tester.enterText(
        find.byKey(const Key('BookcaseNameTextFormField')),
        'New Bookcase Name',
      );
      await tester.tap(find.byKey(const Key('ConfirmBookcaseInsertionButton')));
      await tester.pumpAndSettle();

      expect(find.text('Updated successfully'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(BookcaseInsertionPage), findsNothing);
    });
  });
}

Future<void> _initBookcaseInsertionPage(
  WidgetTester tester,
  BookcaseInsertionBloc bookcaseBloc, [
  BookcaseModel? bookcase,
]) async {
  await tester.pumpWidget(
    BlocProvider.value(
      value: bookcaseBloc,
      child: MaterialApp(
        home: bookcase == null
            ? BookcaseInsertionPage.newBookcase()
            : BookcaseInsertionPage.updateBookcase(
                bookcaseModel: bookcase,
              ),
      ),
    ),
  );
}
