import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthLoadingState()) {
    on<SignedInAuthEvent>(_signedInAuthEvent);
  }

  Future<void> _signedInAuthEvent(
    SignedInAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());

      int authSignedIn = 0;

      if (event.buttonType == 1) {
        authSignedIn = await _authService.signIn(
          signInType: SignInType.google,
        );
      } else if (event.buttonType == 2) {
        authSignedIn = await _authService.signIn(
          signInType: SignInType.apple,
        );
      } else {
        authSignedIn = await _authService.signIn(
          signInType: SignInType.facebook,
        );
      }

      if (authSignedIn == 0) {
        emit(
          AuthErrorState(
            errorMessage: 'Impossível efetuar a autentificação',
          ),
        );
        return;
      }

      emit(AuthSignedState());
    } on AuthException catch (e) {
      emit(
        AuthErrorState(
          errorMessage: 'Erro na autentificação: ${e.message}',
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
