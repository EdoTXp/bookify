import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const qrCodeScannerWidgetKey = Key('qrCodeScannerWidget');
const changeModeTextButtonKey = Key('changeModeTextButton');
const isbnManuallyTextFormFieldWidgetKey =
    Key('isbnManuallyTextFormFieldWidget');
const isbnManuallyOutlinedButtonKey = Key('isbnManuallyOutlinedButton');
const isbnManuallyTextFormFieldKey = Key('isbnManuallyTextFormField');

void main() {
  group('Test QR_CodeScanner Widget ||', () {
    testWidgets('MobileScanner is ready', (tester) async {
      await _pumpWidget(tester);
      expect(find.byKey(qrCodeScannerWidgetKey), findsOneWidget);
      expect(find.byKey(const Key('MobileScanner')), findsOneWidget);
      expect(find.byKey(changeModeTextButtonKey), findsOneWidget);
    });
  });

  group('Test ISBN manually Widget ||', () {
    testWidgets('enter a manually text for ISBN10', (tester) async {
      await _pumpWidget(tester);

      String isbn10 = '5555555555';
      await _testIsbn(isbnVersion: isbn10, tester);
    });

    testWidgets('enter a manually text for ISBN10 with X', (tester) async {
      await _pumpWidget(tester);

      String isbn10WithX = '555555555X';
      await _testIsbn(isbnVersion: isbn10WithX, tester);
    });

    testWidgets('enter a manually text for ISBN13', (tester) async {
      await _pumpWidget(tester);

      String isbn13 = '55555555555555';
      await _testIsbn(isbnVersion: isbn13, tester);
    });
  });
}

Future<void> _testIsbn(
  WidgetTester tester, {
  required String isbnVersion,
}) async {
  const notEmptyField = 'field-cannot-be-empty-error';
  const isbnInvalid = 'invalid-ISBN-format-error';

  // Expect that qrCodeScannerWidget is constructed
  expect(find.byKey(qrCodeScannerWidgetKey), findsOneWidget);

  // Change to IsbnManuallyTextFormFieldWidget
  await tester.tap(find.byKey(changeModeTextButtonKey));
  await tester.pump();

  // Expect that IsbnManuallyTextFormFieldWidget, IsbnManuallyTextFormField and BookifyButton are constructed
  expect(find.byKey(isbnManuallyTextFormFieldWidgetKey), findsOneWidget);
  expect(find.byKey(isbnManuallyTextFormFieldKey), findsOneWidget);
  expect(find.byKey(isbnManuallyOutlinedButtonKey), findsOneWidget);

  // Test that the text appears: 'Esse campo não pode estar vazio'
  await tester.tap(find.byKey(isbnManuallyOutlinedButtonKey));
  await tester.pump();
  expect(find.text(notEmptyField), findsOneWidget);

  // Insert 9 initial isbn text on IsbnManuallyTextFormField, click to Bookify Button and expect invalid text
  await tester.enterText(find.byKey(isbnManuallyTextFormFieldKey), '555555555');
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(isbnManuallyOutlinedButtonKey));
  await tester.pump();
  expect(find.text(isbnInvalid), findsOneWidget);

  // Update mask
  await tester.enterText(find.byKey(isbnManuallyTextFormFieldKey), isbnVersion);
  await tester.pumpAndSettle();

  // Add more numbers and click for validate a textFormField
  await tester.enterText(find.byKey(isbnManuallyTextFormFieldKey), isbnVersion);
  await tester.pumpAndSettle();

  // Checks that texts do not appear
  expect(find.text(notEmptyField), findsNothing);
  expect(find.text(isbnInvalid), findsNothing);

  // Click to send isbnVersion to validate
  await tester.tap(find.byKey(isbnManuallyOutlinedButtonKey));
  await tester.pumpAndSettle();

  // Expect the page to be disposed
  expect(find.byKey(qrCodeScannerWidgetKey), findsNothing);
  expect(find.byKey(isbnManuallyTextFormFieldWidgetKey), findsNothing);
  expect(find.byKey(changeModeTextButtonKey), findsNothing);
  expect(find.byKey(isbnManuallyTextFormFieldKey), findsNothing);
  expect(find.byKey(isbnManuallyOutlinedButtonKey), findsNothing);
}

Future<void> _pumpWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: QrCodeScannerPage(),
    ),
  );
}
