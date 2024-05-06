import 'package:bookify/src/shared/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/shared/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:bookify/src/shared/storage/storage.dart';
import 'package:flutter/material.dart';

class UserThemeRepositoryImpl implements UserThemeRepository {
  final Storage _storage;
  final String _themeKey = 'theme';

  const UserThemeRepositoryImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<ThemeMode?> getThemeMode() async {
    try {
      final theme = await _storage.getStorage(key: _themeKey) as int?;

      switch (theme) {
        case 1:
          return ThemeMode.light;
        case 2:
          return ThemeMode.dark;
        case 3:
          return ThemeMode.system;
        default:
          return null;
      }
    } on TypeError {
      throw StorageException('impossível converter o tema.');
    } on StorageException {
      rethrow;
    }
  }

  @override
  Future<int> setThemeMode({required ThemeMode themeMode}) async {
    try {
      final themeInserted = await _storage.insertStorage(
        key: _themeKey,
        value: themeMode.index,
      );
      return themeInserted;
    } on StorageException {
      rethrow;
    }
  }
}
