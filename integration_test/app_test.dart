import 'dart:io';

import 'package:bookify/firebase_options.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:bookify/src/shared/providers/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:patrol/patrol.dart';
import 'package:provider/provider.dart';

late final MobileAutomator native;
void main() {
  patrolTest('Test E2E App with Patrol', ($) async {
    native = $.platformAutomator.mobile;

    await _initApp($);
    await $.pumpAndSettle();
    await _configureApp($);
    await $.pumpAndSettle();
    await _testHomePage($);
    await $.pumpAndSettle();
    await _testBookcasePage($);
    await $.pumpAndSettle();
    await _testLoanPage($);
    await $.pumpAndSettle();
    await $.pumpAndSettle();
    await _testReadingsPage($);
  });
}

Future<void> _testerPop(PatrolIntegrationTester $) async {
  final NavigatorState navigator = $.tester.state(find.byType(Navigator));
  navigator.pop();
  await $.pumpAndSettle();
}

Future<void> _initApp(PatrolIntegrationTester $) async {
  await initializeDateFormatting(Platform.localeName);
  Intl.defaultLocale = Platform.localeName;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await $.pumpWidgetAndSettle(
    MultiProvider(
      providers: Providers.providers,
      child: BookifyApp(),
    ),
  );
}

Future<void> _configureApp(PatrolIntegrationTester $) async {
  await _testOnboardingPage($);
  await _testLoginPage($);
  await _testReadingSettingsPages($);
}

Future<void> _testOnboardingPage(PatrolIntegrationTester $) async {
  if (await native.isPermissionDialogVisible()) {
    await native.grantPermissionWhenInUse();
  }

  //navigate onboarding.
  expect($(#Illustration1), findsOneWidget);
  expect($(#NextButton), findsOneWidget);

  await $(#NextButton).tap();

  expect($(#Illustration1), findsNothing);
  expect($(#Illustration2), findsOneWidget);
  expect($(#NextButton), findsOneWidget);

  await $(#NextButton).tap();

  expect($(#Illustration2), findsNothing);
  expect($(#Illustration3), findsOneWidget);
  expect($(#NextButton), findsOneWidget);

  await $(#NextButton).tap();

  expect($(#Illustration3), findsNothing);
  expect($(#Illustration4), findsOneWidget);
  expect($(#NextButton), findsOneWidget);

  await $(#NextButton).tap();

  expect($(#Illustration4), findsNothing);
  expect($(#NextButton), findsNothing);
}

Future<void> _testLoginPage(PatrolIntegrationTester $) async {
  Platform.isAndroid
      ? expect($(#GoogleButton), findsOneWidget)
      : expect($(#AppleButton), findsOneWidget);

  expect($(#FacebookButton), findsOneWidget);
  expect($(#BookifyLogoImage), findsOneWidget);

  await $(#FacebookButton).tap();

  //! At this time, the test device "MUST" already be logged
  // in to Facebook in order to access the app.
  await _tapOnNativeLoginButton();
  await $.pumpAndSettle(duration: const Duration(seconds: 5));

  // If login successful, expect the page to be disposed.
  expect($(#GoogleButton), findsNothing);
  expect($(#AppleButton), findsNothing);
  expect($(#FacebookButton), findsNothing);
  expect($(#BookifyLogoImage), findsNothing);
}

Future<void> _tapOnNativeLoginButton() async {
  final facebookLoginSelector = MobileSelector(
    ios: IOSSelector(
      textContains: 'Continua come',
      elementType: IOSElementType.button,
    ),
    android: AndroidSelector(
      textContains: 'Continua come',
      isClickable: true,
    ),
  );

  await native.waitUntilVisible(facebookLoginSelector);
  await native.tap(facebookLoginSelector);
}

Future<void> _testReadingSettingsPages(PatrolIntegrationTester $) async {
  // navigate to reading calculate page
  expect($(#LateCalculateReadingButton), findsOneWidget);

  await $(#LateCalculateReadingButton).tap();
  await $.pumpAndSettle();

  expect($(#LateCalculateReadingButton), findsNothing);

  // navigate to hour reading calculate
  expect($(#LateCalculateHourButton), findsOneWidget);
  await $(#LateCalculateHourButton).tap();
  await $.pumpAndSettle();
  expect($(#LateCalculateHourButton), findsNothing);
}

Future<void> _testHomePage(PatrolIntegrationTester $) async {
  expect($(#AnimatedSearchBar), findsOneWidget);
  expect($(#SearchBar), findsOneWidget);
  expect($(#BooksGridView), findsOneWidget);
  expect($(#BookWidget), findsWidgets);
  expect($(#SearchTypeButton), findsOneWidget);

  // Tap to search bar on home page
  await $(#SearchTypeButton).tap();
  await $.pumpAndSettle();

  expect($(#TitleSearchTypeButton), findsOneWidget);
  expect($(#AuthorSearchTypeButton), findsOneWidget);
  expect($(#CategorySearchTypeButton), findsOneWidget);
  expect($(#PublisherSearchTypeButton), findsOneWidget);
  expect($(#ISBNSearchTypeButton), findsOneWidget);

  // Tap to ISBN button to search by ISBN
  await $(#ISBNSearchTypeButton).tap();
  await $.pumpAndSettle();

  expect($('enter-isbn-label'.i18n()), findsOneWidget);

  // Enter ISBN Text and send request
  await $(#SearchBar).enterText('9788542221084');
  await $.tester.testTextInput.receiveAction(TextInputAction.done);
  await $.pumpAndSettle();

  expect($(#BooksGridView), findsOneWidget);
  expect($(#BookWidget), findsWidgets);

  // tap on first book and open book detail
  await $(find.byTooltip('Memórias póstumas de Brás Cubas')).tap();
  await $.pumpAndSettle();

  expect($(Icons.bookmark_border), findsOneWidget);
  expect($(#InsertOrRemoveBookButton), findsOneWidget);
  expect($('add-button'.i18n()), findsOneWidget);

  // Add book to my books bookcase
  await $(#InsertOrRemoveBookButton).tap();
  await $.pumpAndSettle();

  expect($(Icons.bookmark), findsOneWidget);
  expect($(#InsertOrRemoveBookButton), findsOneWidget);
  expect($('remove-button'.i18n()), findsOneWidget);

  // Back to home page
  await _testerPop($);
}

Future<void> _testBookcasePage(PatrolIntegrationTester $) async {
  // Navigate to Bookcase PageView
  await $('bookcases-label'.i18n()).tap();
  await $.pumpAndSettle();

  // Open bookcase insertion page
  expect($(#BookcaseEmptyState), findsOneWidget);

  await $(#BookcaseEmptyState).tap();
  await $.pumpAndSettle();

  expect($(#BookcaseNameTextFormField), findsOneWidget);
  expect($(#BookcaseDescriptionTextFormField), findsOneWidget);
  expect($(#BookcaseColorTextFormField), findsOneWidget);
  expect($(#ConfirmBookcaseInsertionButton), findsOneWidget);

  //Create new bookcase
  await $(#BookcaseNameTextFormField).enterText('Estante A');
  await $.pumpAndSettle();
  await $(#BookcaseDescriptionTextFormField).enterText(
    'Ficção Literária Literatura e Ficção',
  );
  await $.pumpAndSettle();
  await $(#ConfirmBookcaseInsertionButton).tap();
  await $.pumpAndSettle(duration: const Duration(seconds: 4));

  // Back to bookcase page and check if bookcase is created
  expect($(#BookcaseLoadedState), findsOneWidget);
  expect($(#BookcaseWidget), findsOneWidget);

  // Open bookcase Widget
  await $(#BookcaseWidget).tap();
  await $.pumpAndSettle();

  expect($('Estante A'), findsOneWidget);
  expect($('Ficção Literária Literatura e Ficção'), findsOneWidget);

  final booksEmptyTextLabel = '0 ${'books-label'.i18n()}';
  expect($(booksEmptyTextLabel), findsOneWidget);
  expect($(#BookcaseDetailBooksEmptyState), findsOneWidget);

  // Insert book to bookcase
  await $(#ItemEmptyStateButton).tap();
  await $.pumpAndSettle();

  expect($(#BookcaseBooksInsertionLoadedStateWidget), findsOneWidget);
  expect($(#BookInsertionWidget), findsOneWidget);

  await $(#BookInsertionWidget).tap();
  await $.pumpAndSettle();
  await $(#ConfirmBookIconButton).tap();
  await $.pumpAndSettle();

  final bookAddedTextLabel = '1 ${'book-label'.i18n()}';
  expect($(bookAddedTextLabel), findsOneWidget);
  await $.pumpAndSettle();

  // Back to bookcase page
  await _testerPop($);
}

Future<void> _insertBookPicker(PatrolIntegrationTester $) async {
  expect($(#BookcaseBookSwitch), findsOneWidget);
  await $(#BookcaseBookSwitch).tap();
  await $.pumpAndSettle();

  expect($(#BookSelectorWidget), findsOneWidget);

  await $(#BookWidget).tap();
  await $.pumpAndSettle();

  expect($(#BookWidget), findsNothing);
  expect($(#SelectedBookWidget), findsOneWidget);

  await $(#ConfirmIconButton).tap();
  await $.pumpAndSettle();
}

Future<void> setDurationOfLoan(PatrolIntegrationTester $) async {
  final int todayInicialLoan = DateTime.now().day;

  // Set loan date and devolution date
  await $(#LoanDateTextFormField).tap();
  await $.pumpAndSettle();

  await $('$todayInicialLoan').tap();
  await $.pumpAndSettle();

  await $('OK').tap();
  await $.pumpAndSettle();

  await $(#DevolutionDateTextFormField).tap();
  await $.pumpAndSettle();

  final int devolutionLoanDay;

  /* If today is the last day of the month,
   the devolution date will be the first day of the next month
  */
  if (todayInicialLoan >= 29) {
    await $(find.byTooltip('next-month-tooltip'.i18n())).tap();
    await $.pumpAndSettle();
    devolutionLoanDay = 1;
  } else {
    devolutionLoanDay = todayInicialLoan + 1;
  }

  await $('$devolutionLoanDay').tap();
  await $.pumpAndSettle();

  await $('OK').tap();
  await $.pumpAndSettle();
}

Future<void> _testLoanPage(PatrolIntegrationTester $) async {
  // Go to Loan Page
  await $(#LoanTabView).tap();
  await $.pumpAndSettle();

  // Insert new loan
  expect($(#LoanEmptyState), findsOneWidget);
  await $(#LoanEmptyState).tap();
  await $.pumpAndSettle();

  // Insert book for loan
  await $(#EmptyBookButtonWidget).tap();
  await $.pumpAndSettle();

  await _insertBookPicker($);
  expect($(#SelectedBookButtonWidget), findsOneWidget);

  // Insert contact for loan
  expect($(#EmptyContactButtonWidget), findsOneWidget);
  await $(#EmptyContactButtonWidget).tap();

  if (await native.isPermissionDialogVisible()) {
    await native.grantPermissionWhenInUse();
  }

  expect($(#ContactsPickerLoadedStateWidget), findsOneWidget);
  expect($(#ContactWidget), findsWidgets);

  final firstContact = $(#ContactWidget).evaluate().first;
  await $((firstContact.widget)).tap();
  await $.pumpAndSettle();

  await $(#ContactConfirmButton).tap();
  await $.pumpAndSettle();

  expect($(#EmptyContactButtonWidget), findsNothing);
  expect($(#ContactCircleAvatar), findsOneWidget);

  // Insert observation for loan
  await $(#ObservationTextFormField).enterText('Amigo');
  await $.pumpAndSettle();

  // Insert dates for loan
  await setDurationOfLoan($);

  // Confirm loan
  await $(#ConfirmLoanButton).tap();
  await $.pumpAndSettle(duration: const Duration(seconds: 4));

  // Open Loan Detail
  expect($(#LoanLoadedState), findsOneWidget);
  expect($(#LoanWidget), findsOneWidget);

  await $(#LoanWidget).tap();
  await $.pumpAndSettle();
  expect($(#LoanDetailLoadedState), findsOneWidget);

  // Finalize Loan
  await $(#FinishLoanButton).tap();
  await $.pumpAndSettle();

  await $(#ConfirmDialogButton).tap();
  await $.pumpAndSettle();

  expect($(#LoanDetailLoadedState), findsNothing);
  expect($(#LoanEmptyState), findsOneWidget);
}

Future<void> _testReadingsPage(PatrolIntegrationTester $) async {
  // Navigate to Readings PageView
  await $('readings-label'.i18n()).tap();
  await $.pumpAndSettle();
  expect($(#ReadingsEmptyState), findsOneWidget);

  // Get book and insert new reading
  await $(#ReadingsEmptyState).tap();
  await $.pumpAndSettle();
  await _insertBookPicker($);

  await $(#AddReadingButton).tap();
  await $.pumpAndSettle(duration: const Duration(seconds: 4));

  expect($(#ReadingsLoadedState), findsOneWidget);
  expect($(#ReadingWidget), findsOneWidget);

  // Expect to find a new reading
  expect($('0%'), findsOneWidget);

  // Open Reading Detail
  await $(#ReadingWidget).tap();
  await $.pumpAndSettle();

  // Open Reading Timer
  await $(#ContinueReadingButton).tap();
  await $.pumpAndSettle();

  // Finalize reading
  await $(#EndTimerButton).tap();
  await $.pumpAndSettle();
  await $(#OkDialogButton).tap();
  await $.pumpAndSettle();

  // Update reading pages
  await $.tester.drag(
    $(#ReadingSlider),
    const Offset(100, 0),
  );
  await $.pumpAndSettle();

  // Confirm update Reading
  await $(#UpdateOrFinishReadingButton).tap();
  await $.pumpAndSettle();
  await $(#ConfirmDialogButton).tap();
  await $.pumpAndSettle(duration: const Duration(seconds: 4));

  expect($(#ReadingsLoadedState), findsOneWidget);
  expect($(#ReadingWidget), findsOneWidget);

  // Expect to find a updated reading
  expect($('0%'), findsNothing);
}
