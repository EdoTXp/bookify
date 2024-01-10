import 'package:bookify/src/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/root/views/root_page.dart';
import 'shared/providers/providers.dart';

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
      ],
      child: MaterialApp(
        title: 'Bookify',
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        themeMode: ThemeMode.system,
        home: const RootPage(),
      ),
    );
  }
}
