import 'package:bookify/src/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentations/home/providers/book_showcase_providers.dart';
import 'presentations/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...bookShowcaseProviders,
      ],
      child:  MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.light,
        home: const HomePage(),
      ),
    );
  }
}
