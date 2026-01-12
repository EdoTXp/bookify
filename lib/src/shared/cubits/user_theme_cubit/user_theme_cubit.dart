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
    } on StorageException catch (e) {
      emit(
        UserThemeErrorState(
          errorMessage: 'erro ao buscar o tema: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        UserThemeErrorState(
          errorMessage: 'Erro inesperado: $e',
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
            errorMessage: 'erro ao inserir o tema',
          ),
        );
        return;
      }

      emit(
        UserThemeLoadedState(themeMode: themeMode),
      );
    } on StorageException catch (e) {
      emit(
        UserThemeErrorState(
          errorMessage: 'erro ao inserir o tema: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        UserThemeErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
