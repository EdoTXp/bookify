import 'dart:io';

import 'package:bookify/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  testWidgets('Test E2E App', (tester) async {
    await _configureApp(tester);
    await tester.pumpAndSettle();
    await _testHomePage(tester);
    await tester.pumpAndSettle();
    await _testBookcasePage(tester);
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
  await tester.pumpAndSettle(const Duration(seconds: 4));

  // login successful, expect the page to be disposed.
  expect(find.byKey(const Key('Google Button')), findsNothing);
  expect(find.byKey(const Key('Apple Button')), findsNothing);
  expect(find.byKey(const Key('Facebook Button')), findsNothing);
}

Future<void> _testReadingSettingsPages(WidgetTester tester) async {
  // navigate to reading calculate page
  expect(
      find.byKey(const Key('Late Calculate Reading Button')), findsOneWidget);
  // wait 10 seconds for hide possible snackbar
  await tester.pumpAndSettle(const Duration(seconds: 4));
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

  expect(find.text('Digite o ISBN'), findsOneWidget);

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
  expect(find.text('Adicionar'), findsOneWidget);

  // Add book to my books bookcase
  await tester.tap(find.byKey(const Key('Insert Or Remove Book Button')));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.bookmark), findsOneWidget);
  expect(find.byKey(const Key('Insert Or Remove Book Button')), findsOneWidget);
  expect(find.text('Remover'), findsOneWidget);

  // Back to home page
  await _testerPop(tester);
}

Future<void> _testBookcasePage(WidgetTester tester) async {
  // Navigate to Bookcase PageView
  await tester.tap(find.text('Estantes'));
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

  expect(
    find.text('0 livros'),
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

  expect(find.text('1 livro'), findsOneWidget);

  // Back to bookcase page
  await tester.pumpAndSettle();
  await _testerPop(tester);
}
