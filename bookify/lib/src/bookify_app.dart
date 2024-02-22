import 'package:bookify/src/shared/providers/providers.dart';
import 'package:bookify/src/shared/routes/routes.dart';
import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookifyApp extends StatelessWidget {
  const BookifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...repositoriesProviders,
        ...servicesProviders,
        ...homePageProviders,
        ...bookDetailPageProviders,
        ...bookcasePageProviders,
        ...bookcaseInsertionPageProviders,
        ...bookcaseDetailPageProviders,
        ...bookcaseBooksInsertionProviders,
        ...myBooksProviders,
      ],
      child: MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.system,
        routes: routes,
        initialRoute: '/',
      ),
    );
  }
}
