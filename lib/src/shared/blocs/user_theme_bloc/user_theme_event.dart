part of 'user_theme_bloc.dart';

sealed class UserThemeEvent {}

final class GotUserThemeEvent extends UserThemeEvent {}

final class InsertedUserThemeEvent extends UserThemeEvent {
  final ThemeMode themeMode;

  InsertedUserThemeEvent({
    required this.themeMode,
  });
}
