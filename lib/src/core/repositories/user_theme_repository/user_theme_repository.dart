import 'package:flutter/material.dart';

abstract interface class UserThemeRepository {
  Future<ThemeMode?> getThemeMode();
  Future<int> setThemeMode({required ThemeMode themeMode});
}
