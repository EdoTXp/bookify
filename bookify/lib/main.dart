import 'package:bookify/src/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/bookify_app.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: Providers.providers,
      child: const BookifyApp(),
    ),
  );
}
