part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSignedState extends AuthState {}

final class AuthErrorState extends AuthState {
  final AuthErrorCode errorCode;
  final String? errorDescriptionMessage;

  AuthErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
