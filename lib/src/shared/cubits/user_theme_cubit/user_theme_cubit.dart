import 'package:bookify/src/core/enums/app_theme_mode.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/data/repositories/user_theme_repository/user_theme_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_theme_state.dart';

class UserThemeCubit extends Cubit<UserThemeState> {
  final UserThemeRepository _userThemeRepository;

  UserThemeCubit(
    this._userThemeRepository,
  ) : super(UserThemeLoadingState());

  AppThemeMode get _currentMode => switch (state) {
    UserThemeLoadedState(appThemeMode: final themeMode) ||
    UserThemeErrorState(appThemeMode: final themeMode) => themeMode,
    UserThemeLoadingState() => AppThemeMode.system,
  };

  Future<void> getTheme() async {
    try {
      emit(UserThemeLoadingState());

      final theme = await _userThemeRepository.getThemeMode();

      emit(UserThemeLoadedState(appThemeMode: theme));
    } on StorageException catch (e) {
      emit(_errorState(AppThemeMode.system, e.code, e.descriptionMessage));
    } on Exception catch (e) {
      emit(
        _errorState(
          AppThemeMode.system,
          StorageErrorCode.unknown,
          e.toString(),
        ),
      );
    }
  }

  Future<void> setTheme({required AppThemeMode appThemeMode}) async {
    final previous = _currentMode;
    emit(UserThemeLoadedState(appThemeMode: appThemeMode));

    try {
      final themeInserted = await _userThemeRepository.setThemeMode(
        appThemeMode: appThemeMode,
      );

      if (themeInserted == 0) {
        emit(
          _errorState(
            previous,
            StorageErrorCode.writeFailed,
            'Failed to save theme. Please try again.',
          ),
        );
      }
    } on StorageException catch (e) {
      emit(_errorState(previous, e.code, e.descriptionMessage));
    } on Exception catch (e) {
      emit(_errorState(previous, StorageErrorCode.unknown, e.toString()));
    }
  }

  UserThemeErrorState _errorState(
    AppThemeMode themeMode,
    StorageErrorCode code,
    String? message,
  ) => UserThemeErrorState(
    appThemeMode: themeMode,
    errorCode: code,
    errorDescriptionMessage: message,
  );
}
