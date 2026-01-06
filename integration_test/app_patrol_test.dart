import 'dart:io';

import 'package:bookify/firebase_options.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:bookify/src/shared/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = FirebaseAuth.instanceFor(app: app);

  await $.pumpWidgetAndSettle(
    MultiProvider(
      providers: Providers.providers,
      child: BookifyApp(
        auth: auth,
      ),
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
  expect($(#Illustration1).exists, true);
  expect($(#NextButton).exists, true);

  await $(#NextButton).tap();

  expect($(#Illustration1).exists, false);
  expect($(#Illustration2).exists, true);
  expect($(#NextButton).exists, true);

  await $(#NextButton).tap();

  expect($(#Illustration2).exists, false);
  expect($(#Illustration3).exists, true);
  expect($(#NextButton).exists, true);

  await $(#NextButton).tap();

  expect($(#Illustration3).exists, false);
  expect($(#Illustration4).exists, true);
  expect($(#NextButton).exists, true);

  await $(#NextButton).tap();

  expect($(#Illustration4).exists, false);
  expect($(#NextButton).exists, false);
}

Future<void> _testLoginPage(PatrolIntegrationTester $) async {
  Platform.isAndroid
      ? expect($(#GoogleButton).exists, true)
      : expect($(#AppleButton).exists, true);

  expect($(#FacebookButton).exists, true);

  await $(#FacebookButton).tap();

  //! At this time, the test device "MUST" already be logged
  // in to Facebook in order to access the app.
  await _tapOnNativeLoginButton();
  await $.pumpAndSettle(duration: const Duration(seconds: 5));

  // If login successful, expect the page to be disposed.
  expect($(#GoogleButton).exists, false);
  expect($(#AppleButton).exists, false);
  expect($(#FacebookButton).exists, false);
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
  expect($(#LateCalculateReadingButton).exists, true);

  await $(#LateCalculateReadingButton).tap();
  await $.pumpAndSettle();

  expect($(#LateCalculateReadingButton).exists, false);

  // navigate to hour reading calculate
  expect($(#LateCalculateHourButton).exists, true);
  await $(#LateCalculateHourButton).tap();
  await $.pumpAndSettle();
  expect($(#LateCalculateHourButton).exists, false);
}

Future<void> _testHomePage(PatrolIntegrationTester $) async {
  expect($(#AnimatedSearchBar).exists, true);
  expect($(#SearchBar).exists, true);
  expect($(#BooksGridView).exists, true);
  expect($(#BookWidget).exists, true);
  expect($(#SearchTypeButton).exists, true);

  // Tap to search bar on home page
  await $(#SearchTypeButton).tap();
  await $.pumpAndSettle();

  expect($(#TitleSearchTypeButton).exists, true);
  expect($(#AuthorSearchTypeButton).exists, true);
  expect($(#CategorySearchTypeButton).exists, true);
  expect($(#PublisherSearchTypeButton).exists, true);
  expect($(#ISBNSearchTypeButton).exists, true);

  // Tap to ISBN button to search by ISBN
  await $(#ISBNSearchTypeButton).tap();
  await $.pumpAndSettle();

  expect($('enter-isbn-label'.i18n()).exists, true);

  // Enter ISBN Text and send request
  await $(#SearchBar).enterText('9788542221084');
  await $.tester.testTextInput.receiveAction(TextInputAction.done);
  await $.pumpAndSettle();

  expect($(#BooksGridView).exists, true);
  expect($(#BookWidget).exists, true);

  // tap on first book and open book detail
  await $(find.byTooltip('Memórias póstumas de Brás Cubas')).tap();
  await $.pumpAndSettle();

  expect($(Icons.bookmark_border).exists, true);
  expect($(#InsertOrRemoveBookButton).exists, true);
  expect($('add-button'.i18n()).exists, true);

  // Add book to my books bookcase
  await $(#InsertOrRemoveBookButton).tap();
  await $.pumpAndSettle();

  expect($(Icons.bookmark).exists, true);
  expect($(#InsertOrRemoveBookButton).exists, true);
  expect($('remove-button'.i18n()).exists, true);

  // Back to home page
  await _testerPop($);
}

Future<void> _testBookcasePage(PatrolIntegrationTester $) async {
  // Navigate to Bookcase PageView
  await $('bookcases-label'.i18n()).tap();
  await $.pumpAndSettle();

  // Open bookcase insertion page
  expect($(#BookcaseEmptyState).exists, true);

  await $(#BookcaseEmptyState).tap();
  await $.pumpAndSettle();

  expect($(#BookcaseNameTextFormField).exists, true);
  expect($(#BookcaseDescriptionTextFormField).exists, true);
  expect($(#BookcaseColorTextFormField).exists, true);
  expect($(#ConfirmBookcaseInsertionButton).exists, true);

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
  expect($(#BookcaseLoadedState).exists, true);
  expect($(#BookcaseWidget).exists, true);

  // Open bookcase Widget
  await $(#BookcaseWidget).tap();
  await $.pumpAndSettle();

  expect($('Estante A').exists, true);
  expect($('Ficção Literária Literatura e Ficção').exists, true);

  final booksEmptyTextLabel = '0 ${'books-label'.i18n()}';
  expect($(booksEmptyTextLabel).exists, true);
  expect($(#BookcaseDetailBooksEmptyState).exists, true);

  // Insert book to bookcase
  await $(#ItemEmptyStateButton).tap();
  await $.pumpAndSettle();

  expect($(#BookcaseBooksInsertionLoadedStateWidget).exists, true);
  expect($(#BookInsertionWidget).exists, true);

  await $(#BookInsertionWidget).tap();
  await $.pumpAndSettle();
  await $(#ConfirmBookIconButton).tap();
  await $.pumpAndSettle();

  final bookAddedTextLabel = '1 ${'book-label'.i18n()}';
  expect($(bookAddedTextLabel).exists, true);
  await $.pumpAndSettle();

  // Back to bookcase page
  await _testerPop($);
}

Future<void> _insertBookPicker(PatrolIntegrationTester $) async {
  expect($(#BookcaseBookSwitch).exists, true);
  await $(#BookcaseBookSwitch).tap();
  await $.pumpAndSettle();

  expect($(#BookSelectorWidget).exists, true);

  await $(#BookWidget).tap();
  await $.pumpAndSettle();

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
  expect($(#LoanEmptyState).exists, true);
  await $(#LoanEmptyState).tap();
  await $.pumpAndSettle();

  // Insert book for loan
  await $(#EmptyBookButtonWidget).tap();
  await $.pumpAndSettle();

  await _insertBookPicker($);
  expect($(#SelectedBookButtonWidget).exists, true);

  // Insert contact for loan
  expect($(#EmptyContactButtonWidget).exists, true);
  await $(#EmptyContactButtonWidget).tap();

  if (await native.isPermissionDialogVisible()) {
    await native.grantPermissionWhenInUse();
  }

  expect($(#ContactsPickerLoadedStateWidget).exists, true);
  expect($(#ContactWidget).exists, true);

  final firstContact = $(#ContactWidget).evaluate().first;
  await $((firstContact.widget)).tap();
  await $.pumpAndSettle();

  await $(#ContactConfirmButton).tap();
  await $.pumpAndSettle();

  expect($(#EmptyContactButtonWidget).exists, false);
  expect($(#ContactCircleAvatar).exists, true);

  // Insert observation for loan
  await $(#ObservationTextFormField).enterText('Amigo');
  await $.pumpAndSettle();

  // Insert dates for loan
  await setDurationOfLoan($);

  // Confirm loan
  await $(#ConfirmLoanButton).tap();
  await $.pumpAndSettle();

  // Open Loan Detail
  await $(#LoanWidget).tap();
  await $.pumpAndSettle();
  expect($(#LoanDetailLoadedState).exists, true);

  // Finalize Loan
  await $(#FinishLoanButton).tap();
  await $.pumpAndSettle();

  await $(#ConfirmDialogButton).tap();
  await $.pumpAndSettle();

  expect($(#LoanDetailLoadedState).exists, false);
  expect($(#LoanEmptyState).exists, true);
}

Future<void> _testReadingsPage(PatrolIntegrationTester $) async {
  // Navigate to Readings PageView
  await $('readings-label'.i18n()).tap();
  await $.pumpAndSettle();
  expect($(#ReadingsEmptyState).exists, true);

  // Get book and insert new reading
  await $(#ReadingsEmptyState).tap();
  await $.pumpAndSettle();
  await _insertBookPicker($);

  await $(#AddReadingButton).tap();
  await $.pumpAndSettle(duration: const Duration(seconds: 4));

  expect($(#ReadingsLoadedState).exists, true);
  expect($(#ReadingWidget).exists, true);

  // Expect to find a new reading
  expect($('0%').exists, true);

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
    const Offset(200, 0),
  );
  await $.pumpAndSettle();

  // Confirm update Reading
  await $(#UpdateOrFinishReadingButton).tap();
  await $.pumpAndSettle();
  await $(#ConfirmDialogButton).tap();
  await $.pumpAndSettle();

  // Expect to find a updated reading
  expect($('0%').exists, false);
}
