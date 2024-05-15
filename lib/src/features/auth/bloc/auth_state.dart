part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSignedState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState({
    required this.errorMessage,
  });
}
