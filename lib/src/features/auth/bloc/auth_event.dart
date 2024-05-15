part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SignedInAuthEvent extends AuthEvent{
  final int buttonType;

   SignedInAuthEvent({
    required this.buttonType,
  });
}
