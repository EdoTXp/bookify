import 'dart:io';

import 'package:bookify/firebase_options.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:bookify/src/shared/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test End-to-End App', () {
    testWidgets('Test Login Page', (tester) async {
      await _initializeApp(tester);
      await tester.pumpAndSettle();
      await _testOnboardingPage(tester);
      await tester.pumpAndSettle();
      await _testLoginPage(tester);
    });
  });
}

Future<void> _initializeApp(WidgetTester tester) async {
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = FirebaseAuth.instanceFor(app: app);

  await tester.pumpWidget(
    MultiProvider(
      providers: Providers.providers,
      child: BookifyApp(
        auth: auth,
      ),
    ),
  );
}

Future<void> _testOnboardingPage(WidgetTester tester) async {
  expect(find.byKey(const Key('Illustration1')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  expect(find.byKey(const Key('Illustration1')), findsNothing);
  expect(find.byKey(const Key('Illustration2')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  expect(find.byKey(const Key('Illustration2')), findsNothing);
  expect(find.byKey(const Key('Illustration3')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

  expect(find.byKey(const Key('Illustration3')), findsNothing);
  expect(find.byKey(const Key('Illustration4')), findsOneWidget);

  await tester.tap(find.byKey(const Key('NextButton')));
  await tester.pumpAndSettle(const Duration(seconds: 1));

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
  await tester.pumpAndSettle(const Duration(seconds: 10));

  expect(find.byKey(const Key('Google Button')), findsNothing);
  expect(find.byKey(const Key('Apple Button')), findsNothing);
  expect(find.byKey(const Key('Facebook Button')), findsNothing);
}
