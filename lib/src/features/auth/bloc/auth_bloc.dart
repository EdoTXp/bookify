import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/enums/sign_in_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitialState()) {
    on<SignedInAuthEvent>(_signedInAuthEvent);
  }

  Future<void> _signedInAuthEvent(
    SignedInAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());

      final int authSignedIn = await _authService.signIn(
        signInType: event.signInTypeButton,
      );

      if (authSignedIn == 0) {
        emit(
          AuthErrorState(
            errorCode: AuthErrorCode.internalError,
            errorDescriptionMessage:
                'Failed to save user data. Please try again.',
          ),
        );
        return;
      }

      emit(AuthSignedState());
    } on AuthException catch (e) {
      emit(
        AuthErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthErrorState(
          errorCode: AuthErrorCode.internalError,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
