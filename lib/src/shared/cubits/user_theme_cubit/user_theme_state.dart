part of 'user_theme_cubit.dart';

sealed class UserThemeState {}

final class UserThemeLoadingState extends UserThemeState {}

final class UserThemeLoadedState extends UserThemeState {
  final AppThemeMode appThemeMode;

  UserThemeLoadedState({
    required this.appThemeMode,
  });
}

final class UserThemeErrorState extends UserThemeState {
  final AppThemeMode appThemeMode;
  final StorageErrorCode errorCode;
  final String? errorDescriptionMessage;

  UserThemeErrorState({
    required this.appThemeMode,
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
