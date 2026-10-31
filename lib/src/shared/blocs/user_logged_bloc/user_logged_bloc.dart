import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/domain/services/auth_service/auth_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_logged_state.dart';
part 'user_logged_event.dart';

class UserLoggedBloc extends Bloc<UserLoggedEvent, UserLoggedState> {
  final AuthService _authService;

  UserLoggedBloc(
    this._authService,
  ) : super(UserLoggedLoadingState()) {
    on<CheckedAuthStatusEvent>(_checkAuthStatus);
  }

  Future<void> _checkAuthStatus(
    UserLoggedEvent event,
    Emitter<UserLoggedState> emit,
  ) async {
    try {
      emit(UserLoggedLoadingState());

      return await emit.onEach(
        _authService.userIsLoggedIn(),
        onData: (isLoggedIn) => emit(
          UserLoggedLoadedState(isLoggedIn: isLoggedIn),
        ),
        onError: addError,
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
