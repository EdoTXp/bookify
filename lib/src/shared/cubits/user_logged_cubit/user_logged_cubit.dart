import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_logged_state.dart';

class UserLoggedCubit extends Cubit<UserLoggedState> {
  final AuthService _authService;

  UserLoggedCubit(
    this._authService,
  ) : super(UserLoggedLoadingState());

  Future<void> checkAuthStatus() async {
    try {
      emit(UserLoggedLoadingState());

      final isLoggedIn = await _authService.userIsLoggedIn();

      emit(
        UserLoggedLoadedState(isLoggedIn: isLoggedIn),
      );
    } on AuthException catch (e) {
      emit(
        UserLoggedErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        UserLoggedErrorState(
          errorCode: AuthErrorCode.internalError,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
