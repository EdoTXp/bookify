import 'package:bookify/src/core/repositories/auth_repository/auth_repository.dart';
import 'package:bookify/src/core/repositories/auth_repository/auth_repository_impl.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository_impl.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository_impl.dart';
import 'package:bookify/src/core/storage/shared_preference_storage.dart';
import 'package:bookify/src/core/storage/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

final userSettingsStorageProviders = [
  Provider<Storage>(
    create: (_) => SharedPreferencesStorage(),
  ),
  RepositoryProvider<UserThemeRepository>(
    create: (context) => UserThemeRepositoryImpl(
      storage: context.read(),
    ),
  ),
  RepositoryProvider<AuthRepository>(
    create: (context) => AuthRepositoryImpl(
      storage: context.read(),
    ),
  ),
  RepositoryProvider<UserPageReadingTimeRepository>(
    create: (context) => UserPageReadingTimeRepositoryImpl(
      storage: context.read(),
    ),
  ),
];
