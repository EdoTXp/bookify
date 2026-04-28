part of 'user_logged_cubit.dart';

@immutable
sealed class UserLoggedState {}

final class UserLoggedLoadingState extends UserLoggedState {}

final class UserLoggedLoadedState extends UserLoggedState {
  final bool isLoggedIn;

  UserLoggedLoadedState({
    required this.isLoggedIn,
  });
}

final class UserLoggedErrorState extends UserLoggedState {
  final AuthErrorCode errorCode;
  final String? errorDescriptionMessage;

  UserLoggedErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
