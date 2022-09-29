import 'package:bookify/src/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/presentations/home/providers/book_showcase_providers.dart';
import 'features/presentations/home/views/home_page.dart';

class BookifyApp extends StatelessWidget {
  const BookifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...bookShowcaseProviders,
      ],
      child: MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
