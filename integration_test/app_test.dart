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
  expect(find.byKey(const Key('Bookcase / Book Switch')), findsOneWidget);
  await tester.tap(find.byKey(const Key('Bookcase / Book Switch')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Book Selector Widget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('Book Widget')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Book Widget')), findsNothing);
  expect(find.byKey(const Key('Selected Book Widget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('Confirm IconButton')));
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
      ? expect(find.byKey(const Key('Google Button')), findsOneWidget)
      : expect(find.byKey(const Key('Apple Button')), findsOneWidget);

  expect(find.byKey(const Key('Facebook Button')), findsOneWidget);

  Platform.isAndroid
      ? await tester.tap(find.byKey(const Key('Google Button')))
      : await tester.tap(find.byKey(const Key('Facebook Button')));

  // wait to allow you to log in.
  await tester.pumpAndSettle(const Duration(seconds: 6));

  // login successful, expect the page to be disposed.
  expect(find.byKey(const Key('Google Button')), findsNothing);
  expect(find.byKey(const Key('Apple Button')), findsNothing);
  expect(find.byKey(const Key('Facebook Button')), findsNothing);
}

Future<void> _testReadingSettingsPages(WidgetTester tester) async {
  // navigate to reading calculate page
  expect(
      find.byKey(const Key('Late Calculate Reading Button')), findsOneWidget);
  // wait for hide possible snackbar
  await tester.pumpAndSettle(const Duration(seconds: 6));
  await tester.tap(find.byKey(const Key('Late Calculate Reading Button')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('Late Calculate Reading Button')), findsNothing);

  // navigate to hour reading calculate
  expect(find.byKey(const Key('Late Calculate Hour Button')), findsOneWidget);
  await tester.tap(find.byKey(const Key('Late Calculate Hour Button')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('Late Calculate Hour Button')), findsNothing);
}

Future<void> _testHomePage(WidgetTester tester) async {
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('AnimatedSearchBar')), findsOneWidget);
  expect(find.byKey(const Key('BooksGridView')), findsOneWidget);
  expect(find.byKey(const Key('Book Widget')), findsWidgets);
  expect(find.byKey(const Key('Search Type Button')), findsOneWidget);

  // Tap to search bar on home page
  await tester.tap(find.byKey(const Key('Search Type Button')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Title Search Type Button')), findsOneWidget);
  expect(find.byKey(const Key('Author Search Type Button')), findsOneWidget);
  expect(find.byKey(const Key('Category Search Type Button')), findsOneWidget);
  expect(find.byKey(const Key('Publisher Search Type Button')), findsOneWidget);
  expect(find.byKey(const Key('ISBN Search Type Button')), findsOneWidget);

  // Tap to ISBN button to search by ISBN
  await tester.tap(find.byKey(const Key('ISBN Search Type Button')));
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
  expect(find.byKey(const Key('Book Widget')), findsWidgets);

  // tap on first book and open book detail
  await tester.tap(find.byTooltip('Memórias póstumas de Brás Cubas'));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
  expect(find.byKey(const Key('Insert Or Remove Book Button')), findsOneWidget);
  expect(find.text('add-button'.i18n()), findsOneWidget);

  // Add book to my books bookcase
  await tester.tap(find.byKey(const Key('Insert Or Remove Book Button')));
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
  expect(find.byKey(const Key('Bookcase Empty State')), findsOneWidget);

  await tester.tap(find.byKey(const Key('Bookcase Empty State')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('Bookcase name TextFormField')),
    findsOneWidget,
  );
  expect(
    find.byKey(const Key('Bookcase description TextFormField')),
    findsOneWidget,
  );
  expect(
    find.byKey(const Key('Bookcase color TextFormField')),
    findsOneWidget,
  );
  expect(
    find.byKey(const Key('Confirm Bookcase insertion Button')),
    findsOneWidget,
  );

  //Create new bookcase
  await tester.enterText(
    find.byKey(const Key('Bookcase name TextFormField')),
    'Estante A',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.enterText(
    find.byKey(const Key('Bookcase description TextFormField')),
    'Ficção Literária Literatura e Ficção',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Confirm Bookcase insertion Button')));
  // Wait loading of snackbar
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('Bookcase Loaded State')), findsOneWidget);
  expect(find.byKey(const Key('Bookcase Widget')), findsOneWidget);

  // Open bookcase Widget
  await tester.tap(find.byKey(const Key('Bookcase Widget')));
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
    find.byKey(const Key('Bookcase Detail Books Empty State')),
    findsOneWidget,
  );

  // Insert book to bookcase
  await tester.tap(find.byKey(const Key('Item Empty State Button')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('Bookcase Books Insertion LoadedState Widget')),
    findsOneWidget,
  );
  expect(
    find.byKey(const Key('Book insertion Widget')),
    findsOneWidget,
  );
  await tester.tap(find.byKey(const Key('Book insertion Widget')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('Confirm book IconButton')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  final bookAddedTextLabel = '1 ${'book-label'.i18n()}';
  expect(find.text(bookAddedTextLabel), findsOneWidget);

  // Back to bookcase page
  await tester.pumpAndSettle();
  await _testerPop(tester);
}

Future<void> _testLoanPage(WidgetTester tester) async {
  // Go to Loan Page
  await tester.tap(find.byKey(const Key('Loan TabView')));
  await tester.pumpAndSettle();

  // Insert new  loan
  expect(find.byKey(const Key('Loan Empty State')), findsOneWidget);
  await tester.tap(find.byKey(const Key('Loan Empty State')));
  await tester.pumpAndSettle();

  // Insert book for loan
  await tester.tap(find.byKey(const Key('Empty Book Button Widget')));
  await tester.pumpAndSettle();

  await _insertBookPicker(tester);

  expect(find.byKey(const Key('Selected Book Button Widget')), findsOneWidget);

  // Insert contact for loan
  expect(find.byKey(const Key('Empty Contact Button Widget')), findsOneWidget);
  await tester.tap(find.byKey(const Key('Empty Contact Button Widget')));
  await tester.pumpAndSettle();

  expect(
    find.byKey(const Key('Contacts Picker LoadedState Widget')),
    findsOneWidget,
  );

  expect(find.byKey(const Key('Contact Widget')), findsWidgets);

  final firstContact = find.byKey(const Key('Contact Widget')).evaluate().first;
  await tester.tap(find.byWidget(firstContact.widget));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Confirm Button')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Empty Contact Button Widget')), findsNothing);
  expect(find.byKey(const Key('Contact Circle Avatar')), findsOneWidget);

  // Insert observation for loan
  await tester.enterText(
    find.byKey(const Key('Observation TextFormField')),
    'Amigo',
  );
  await tester.pumpAndSettle();

  // Insert dates for loan
  await setDurationOfLoan(tester);

  // Confirm loan
  await tester.tap(find.byKey(const Key('Confirm Loan Button')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // Open Loan Detail
  expect(find.byKey(const Key('Loan Loaded State')), findsOneWidget);
  expect(find.byKey(const Key('Loan Widget')), findsOneWidget);

  await tester.tap(find.byKey(const Key('Loan Widget')));
  await tester.pumpAndSettle();

  expect(find.byKey(const Key('Loan Detail LoadedState')), findsOneWidget);

  // Finalize Loan
  await tester.tap(find.byKey(const Key('Finish loan Button')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Confirm Dialog Button')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('Loan Loaded State')), findsNothing);
  expect(find.byKey(const Key('Loan Empty State')), findsOneWidget);
}

Future<void> setDurationOfLoan(WidgetTester tester) async {
  final int todayInicialLoan = DateTime.now().day;

// Set loan date and devolution date
  await tester.tap(find.byKey(const Key('Loan Date TextFormField')));
  await tester.pumpAndSettle();

  await tester.tap(find.text('$todayInicialLoan'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('Devolution Date TextFormField')));
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
  expect(find.byKey(const Key('Readings EmptyState')), findsOneWidget);

  // Get book and insert new reading
  await tester.tap(find.byKey(const Key('Readings EmptyState')));
  await tester.pumpAndSettle();
  await _insertBookPicker(tester);

  await tester.tap(find.byKey(const Key('Add Reading Button')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('Readings LoadedState')), findsOneWidget);
  expect(find.byKey(const Key('Reading Widget')), findsOneWidget);

  // Expect to find a new reading
  expect(find.text('0%'), findsOneWidget);

  // Open Reading Detail
  await tester.tap(find.byKey(const Key('Reading Widget')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // Open Reading Timer
  await tester.tap(find.byKey(const Key('Continue Reading Button')));
  await tester.pumpAndSettle();

  // Finalize reading
  await tester.tap(find.byKey(const Key('End Timer Button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('Ok Dialog Button')));
  await tester.pumpAndSettle();

  // Update reading pages
  await tester.drag(
    find.byKey(const Key('Reading Slider')),
    const Offset(100, 0),
  );
  await tester.pumpAndSettle();

  // Confirm update Reading
  await tester.tap(find.byKey(const Key('Update / Finish Reading Button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('Confirm Dialog Button')));
  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.byKey(const Key('Readings LoadedState')), findsOneWidget);
  expect(find.byKey(const Key('Reading Widget')), findsOneWidget);

  // Expect to find a updated reading
  expect(find.text('0%'), findsNothing);
}
