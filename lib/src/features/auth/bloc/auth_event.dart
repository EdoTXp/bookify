part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SignedInAuthEvent extends AuthEvent {
  final SignInType signInTypeButton;

  SignedInAuthEvent({
    required this.signInTypeButton,
  });
}
