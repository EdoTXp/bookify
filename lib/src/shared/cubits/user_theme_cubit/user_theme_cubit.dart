import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_theme_state.dart';

class UserThemeCubit extends Cubit<UserThemeState> {
  final UserThemeRepository _userThemeRepository;

  UserThemeCubit(
    this._userThemeRepository,
  ) : super(UserThemeLoadingState());

  Future<void> getTheme() async {
    try {
      emit(UserThemeLoadingState());

      final theme = await _userThemeRepository.getThemeMode();

      if (theme == null) {
        await _userThemeRepository.setThemeMode(
          themeMode: ThemeMode.system,
        );
        emit(
          UserThemeLoadedState(themeMode: ThemeMode.system),
        );
        return;
      }

      emit(
        UserThemeLoadedState(themeMode: theme),
      );
    } on StorageException {
      emit(
        UserThemeErrorState(
          errorCode: StorageErrorCode.readFailed,
          errorDescriptionMessage: ' Failed to load theme. Please try again.',
        ),
      );
    } on Exception {
      emit(
        UserThemeErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<void> setTheme({required ThemeMode themeMode}) async {
    try {
      emit(UserThemeLoadingState());

      final themeInserted = await _userThemeRepository.setThemeMode(
        themeMode: themeMode,
      );

      if (themeInserted == 0) {
        emit(
          UserThemeErrorState(
            errorCode: StorageErrorCode.writeFailed,
            errorDescriptionMessage: 'Failed to save theme. Please try again.',
          ),
        );
        return;
      }

      emit(
        UserThemeLoadedState(themeMode: themeMode),
      );
    } on StorageException {
      emit(
        UserThemeErrorState(
          errorCode: StorageErrorCode.writeFailed,
          errorDescriptionMessage: 'Failed to save theme. Please try again.',
        ),
      );
    } on Exception {
      emit(
        UserThemeErrorState(
          errorCode: StorageErrorCode.unknown,
          errorDescriptionMessage: 'An unexpected error occurred',
        ),
      );
    }
  }
}
