import 'dart:io';

import 'package:bookify/src/shared/providers/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookify/firebase_options.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await _configApp();

  runApp(
    MultiProvider(
      providers: Providers.providers,
      child: BookifyApp(),
    ),
  );
}

Future<void> _configApp() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await initializeDateFormatting(Platform.localeName);
  Intl.defaultLocale = Platform.localeName;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
