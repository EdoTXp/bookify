import 'dart:io';

import 'package:bookify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:localization/localization.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  testWidgets('Test E2E App', (tester) async {
    await _configureApp(tester);
    await tester.pumpAndSettle();
    await _testHomePage(tester);
    await tester.pumpAndSettle();
    await _testBookcasePage(tester);
    await tester.pumpAndSettle();
    await _testLoanPage(tester);
    await tester.pumpAndSettle();
    await _testReadingsPage(tester);
  });
}

Future<void> _configureApp(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await _testOnboardingPage(tester);
  await tester.pumpAndSettle();
  await _testLoginPage(tester);
  await _testReadingSettingsPages(tester);
}

Future<void> _testerPop(WidgetTester tester) async {
  final NavigatorState navigator = tester.state(find.byType(Navigator));
  navigator.pop();
  await tester.pumpAndSettle();
}

Future<void> _insertBookPicker(WidgetTester tester) async {
  expect(find.byKey(const Key('BookcaseBookSwitch')), findsOneWidget);
  await tester.tap(find.byKey(const Key('BookcaseBookSwitch')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('BookSelectorWidget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('BookWidget')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('BookWidget')), findsNothing);
  expect(find.byKey(const Key('SelectedBookWidget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('ConfirmIconButton')));
  await tester.pumpAndSettle();
}

Future<void> _testOnboardingPage(WidgetTester tester) async {
  //navigate onboarding.
  expect(find.byKey(const Key('Illustration1')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(find.byKey(const Key('Illustration1')), findsNothing);
  expect(find.byKey(const Key('Illustration2')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(find.byKey(const Key('Illustration2')), findsNothing);
  expect(find.byKey(const Key('Illustration3')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(find.byKey(const Key('Illustration3')), findsNothing);
  expect(find.byKey(const Key('Illustration4')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Illustration4')), findsNothing);
  expect(find.byKey(const Key('NextButton')), findsNothing);
}

Future<void> _testLoginPage(WidgetTester tester) async {
  Platform.isAndroid
      ? expect(find.byKey(const Key('GoogleButton')), findsOneWidget)
      : expect(find.byKey(const Key('AppleButton')), findsOneWidget);

  expect(find.byKey(const Key('FacebookButton')), findsOneWidget);

  Platform.isAndroid
      ? await tester.tap(find.byKey(const Key('GoogleButton')))
      : await tester.tap(find.byKey(const Key('FacebookButton')));

  // wait to allow you to log in.
  await tester.pumpAndSettle(const Duration(seconds: 6));

  // login successful, expect the page to be disposed.
  expect(find.byKey(const Key('GoogleButton')), findsNothing);
  expect(find.byKey(const Key('AppleButton')), findsNothing);
  expect(find.byKey(const Key('FacebookButton')), findsNothing);
}

Future<void> _testReadingSettingsPages(WidgetTester tester) async {
  // navigate to reading calculate page
  expect(find.byKey(const Key('LateCalculateReadingButton')), findsOneWidget);
  // wait for hide possible snackbar
  await tester.pumpAndSettle(const Duration(seconds: 6));
  await tester.tap(find.byKey(const Key('LateCalculateReadingButton')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('LateCalculateReadingButton')), findsNothing);

  // navigate to hour reading calculate
  expect(find.byKey(const Key('LateCalculateHourButton')), findsOneWidget);
  await tester.tap(find.byKey(const Key('LateCalculateHourButton')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('LateCalculateHourButton')), findsNothing);
}

Future<void> _testHomePage(WidgetTester tester) async {
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('AnimatedSearchBar')), findsOneWidget);
  expect(find.byKey(const Key('BooksGridView')), findsOneWidget);
  expect(find.byKey(const Key('BookWidget')), findsWidgets);
  expect(find.byKey(const Key('SearchTypeButton')), findsOneWidget);

  // Tap to search bar on home page
  await tester.tap(find.byKey(const Key('SearchTypeButton')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('TitleSearchTypeButton')), findsOneWidget);
  expect(find.byKey(const Key('AuthorSearchTypeButton')), findsOneWidget);
  expect(find.byKey(const Key('CategorySearchTypeButton')), findsOneWidget);
  expect(find.byKey(const Key('PublisherSearchTypeButton')), findsOneWidget);
  expect(find.byKey(const Key('ISBNSearchTypeButton')), findsOneWidget);

  // Tap to ISBN button to search by ISBN
  await tester.tap(find.byKey(const Key('ISBNSearchTypeButton')));
  await tester.pumpAndSettle();

  expect(find.text('enter-isbn-label'.i18n()), findsOneWidget);

  // Enter ISBN Text and send request
  await tester.enterText(
    find.byKey(const Key('AnimatedSearchBar')),
    '9788542221084',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('BooksGridView')), findsOneWidget);
  expect(find.byKey(const Key('BookWidget')), findsWidgets);

  // tap on first book and open book detail
  await tester.tap(find.byTooltip('Memórias póstumas de Brás Cubas'));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  expect(find.byKey(const Key('InsertOrRemoveBookButton')), findsOneWidget);
  expect(find.text('add-button'.i18n()), findsOneWidget);

  // Add book to my books bookcase
  await tester.tap(find.byKey(const Key('InsertOrRemoveBookButton')));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.bookmark), findsOneWidget);
  expect(find.byKey(const Key('Insert Or Remove Book Button')), findsOneWidget);
  expect(find.text('remove-button'.i18n()), findsOneWidget);

  // Back to home page
  await _testerPop(tester);
}

Future<void> _testBookcasePage(WidgetTester tester) async {
  // Navigate to Bookcase PageView
  await tester.tap(find.text('bookcases-label'.i18n()));
  await tester.pumpAndSettle();

  // Open bookcase insertion page
  expect(find.byKey(const Key('BookcaseEmptyState')), findsOneWidget);

  await tester.tap(find.byKey(const Key('BookcaseEmptyState')));
  await tester.pumpAndSettle();

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

  //Create new bookcase
  await tester.enterText(
    find.byKey(const Key('BookcaseNameTextFormField')),
    'Estante A',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.enterText(
    find.byKey(const Key('BookcaseDescriptionTextFormField')),
    'Ficção Literária Literatura e Ficção',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('ConfirmBookcaseInsertionButton')));
  // Wait loading of snackbar
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('BookcaseLoadedState')), findsOneWidget);
  expect(find.byKey(const Key('BookcaseWidget')), findsOneWidget);

  // Open bookcase Widget
  await tester.tap(find.byKey(const Key('BookcaseWidget')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(
    find.text('Estante A'),
    findsOneWidget,
  );
  expect(
    find.text('Ficção Literária Literatura e Ficção'),
    findsOneWidget,
  );

  final booksEmptyTextLabel = '0 ${'books-label'.i18n()}';
  expect(
    find.text(booksEmptyTextLabel),
    findsOneWidget,
  );

  expect(
    find.byKey(const Key('BookcaseDetailBooksEmptyState')),
    findsOneWidget,
  );

  // Insert book to bookcase
  await tester.tap(find.byKey(const Key('ItemEmptyStateButton')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('BookcaseBooksInsertionLoadedStateWidget')),
    findsOneWidget,
  );
  expect(
    find.byKey(const Key('BookInsertionWidget')),
    findsOneWidget,
  );
  await tester.tap(find.byKey(const Key('BookInsertionWidget')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('ConfirmBookIconButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  final bookAddedTextLabel = '1 ${'book-label'.i18n()}';
  expect(find.text(bookAddedTextLabel), findsOneWidget);

  // Back to bookcase page
  await tester.pumpAndSettle();
  await _testerPop(tester);
}

Future<void> _testLoanPage(WidgetTester tester) async {
  // Go to Loan Page
  await tester.tap(find.byKey(const Key('LoanTabView')));
  await tester.pumpAndSettle();

  // Insert new loan
  expect(find.byKey(const Key('LoanEmptyState')), findsOneWidget);
  await tester.tap(find.byKey(const Key('LoanEmptyState')));
  await tester.pumpAndSettle();

  // Insert book for loan
  await tester.tap(find.byKey(const Key('EmptyBookButtonWidget')));
  await tester.pumpAndSettle();

  await _insertBookPicker(tester);

  expect(find.byKey(const Key('SelectedBookButtonWidget')), findsOneWidget);

  // Insert contact for loan
  expect(find.byKey(const Key('EmptyContactButtonWidget')), findsOneWidget);
  await tester.tap(find.byKey(const Key('EmptyContactButtonWidget')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('ContactsPickerLoadedStateWidget')),
    findsOneWidget,
  );

  expect(find.byKey(const Key('ContactWidget')), findsWidgets);

  final firstContact = find.byKey(const Key('ContactWidget')).evaluate().first;
  await tester.tap(find.byWidget(firstContact.widget));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('ContactConfirmButton')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('EmptyContactButtonWidget')), findsNothing);
  expect(find.byKey(const Key('ContactCircleAvatar')), findsOneWidget);

  // Insert observation for loan
  await tester.enterText(
    find.byKey(const Key('ObservationTextFormField')),
    'Amigo',
  );
  await tester.pumpAndSettle();

  // Insert dates for loan
  await setDurationOfLoan(tester);

  // Confirm loan
  await tester.tap(find.byKey(const Key('ConfirmLoanButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // Open Loan Detail
  expect(find.byKey(const Key('LoanLoadedState')), findsOneWidget);
  expect(find.byKey(const Key('LoanWidget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('LoanWidget')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('LoanDetailLoadedState')), findsOneWidget);

  // Finalize Loan
  await tester.tap(find.byKey(const Key('FinishLoanButton')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('ConfirmDialogButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('LoanLoadedState')), findsNothing);
  expect(find.byKey(const Key('LoanEmptyState')), findsOneWidget);
}

Future<void> setDurationOfLoan(WidgetTester tester) async {
  final int todayInicialLoan = DateTime.now().day;

// Set loan date and devolution date
  await tester.tap(find.byKey(const Key('LoanDateTextFormField')));
  await tester.pumpAndSettle();

  await tester.tap(find.text('$todayInicialLoan'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('DevolutionDateTextFormField')));
  await tester.pumpAndSettle();

  final int devolutionLoanDay;

  /* If today is the last day of the month,
   the devolution date will be the first day of the next month
  */
  if (todayInicialLoan >= 29) {
    await tester.tap(find.byTooltip('next-month-tooltip'.i18n()));
    await tester.pumpAndSettle();
    devolutionLoanDay = 1;
  } else {
    devolutionLoanDay = todayInicialLoan + 1;
  }

  await tester.tap(find.text('$devolutionLoanDay'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _testReadingsPage(WidgetTester tester) async {
  // Navigate to Readings PageView
  await tester.tap(find.text('readings-label'.i18n()));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('ReadingsEmptyState')), findsOneWidget);

  // Get book and insert new reading
  await tester.tap(find.byKey(const Key('ReadingsEmptyState')));
  await tester.pumpAndSettle();
  await _insertBookPicker(tester);

  await tester.tap(find.byKey(const Key('AddReadingButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('ReadingsLoadedState')), findsOneWidget);
  expect(find.byKey(const Key('ReadingWidget')), findsOneWidget);

  // Expect to find a new reading
  expect(find.text('0%'), findsOneWidget);

  // Open Reading Detail
  await tester.tap(find.byKey(const Key('ReadingWidget')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // Open Reading Timer
  await tester.tap(find.byKey(const Key('ContinueReadingButton')));
  await tester.pumpAndSettle();

  // Finalize reading
  await tester.tap(find.byKey(const Key('EndTimerButton')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('OkDialogButton')));
  await tester.pumpAndSettle();

  // Update reading pages
  await tester.drag(
    find.byKey(const Key('ReadingSlider')),
    const Offset(100, 0),
  );
  await tester.pumpAndSettle();

  // Confirm update Reading
  await tester.tap(find.byKey(const Key('UpdateOrFinishReadingButton')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('ConfirmDialogButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('ReadingsLoadedState')), findsOneWidget);
  expect(find.byKey(const Key('ReadingWidget')), findsOneWidget);

  // Expect to find a updated reading
  expect(find.text('0%'), findsNothing);
}
