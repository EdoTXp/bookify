import 'package:bookify/src/core/enums/app_theme_mode.dart';
import 'package:material_ui/material_ui.dart';

extension AppThemeModeExtension on AppThemeMode {
  ThemeMode toUIThemeMode() => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

extension ThemeModeExtension on ThemeMode {
  AppThemeMode toAppThemeMode() => switch (this) {
    ThemeMode.system => AppThemeMode.system,
    ThemeMode.light => AppThemeMode.light,
    ThemeMode.dark => AppThemeMode.dark,
  };
}
