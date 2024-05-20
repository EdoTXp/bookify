import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_theme_event.dart';
part 'user_theme_state.dart';

class UserThemeBloc extends Bloc<UserThemeEvent, UserThemeState> {
  final UserThemeRepository _userThemeRepository;

  UserThemeBloc(
    this._userThemeRepository,
  ) : super(UserThemeLoadingState()) {
    on<GotUserThemeEvent>(_gotUserThemeEvent);
    on<InsertedUserThemeEvent>(_insertedUserThemeEvent);
  }

  Future<void> _gotUserThemeEvent(
    GotUserThemeEvent event,
    Emitter<UserThemeState> emit,
  ) async {
    try {
      emit(UserThemeLoadingState());

      final theme = await _userThemeRepository.getThemeMode();

      if (theme == null) {
        await _userThemeRepository.setThemeMode(themeMode: ThemeMode.system);
        emit(UserThemeLoadedState(themeMode: ThemeMode.system));
        return;
      }

      emit(UserThemeLoadedState(themeMode: theme));
    } on StorageException catch (e) {
      emit(UserThemeErrorState(errorMessage: 'erro ao buscar o tema: $e'));
    } on Exception catch (e) {
      emit(
        UserThemeErrorState(errorMessage: 'Erro inesperado: $e'),
      );
    }
  }

  Future<void> _insertedUserThemeEvent(
    InsertedUserThemeEvent event,
    Emitter<UserThemeState> emit,
  ) async {
    try {
      emit(UserThemeLoadingState());

      final themeInserted = await _userThemeRepository.setThemeMode(
        themeMode: event.themeMode,
      );

      if (themeInserted == 0) {
        emit(UserThemeErrorState(errorMessage: 'erro ao inserir o tema'));
        return;
      }

      emit(UserThemeLoadedState(themeMode: event.themeMode));
    } on StorageException catch (e) {
      emit(UserThemeErrorState(errorMessage: 'erro ao inserir o tema: $e'));
    } on Exception catch (e) {
      emit(
        UserThemeErrorState(errorMessage: 'Erro inesperado: $e'),
      );
    }
  }
}
