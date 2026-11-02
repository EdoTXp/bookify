import 'package:bookify/src/core/enums/app_theme_mode.dart';

abstract interface class UserThemeRepository {
  Future<AppThemeMode> getThemeMode();
  Future<int> setThemeMode({required AppThemeMode appThemeMode});
  Future<int> deleteThemeMode();
}
