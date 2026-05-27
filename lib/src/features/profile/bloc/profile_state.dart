part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final UserModel userModel;

  ProfileLoadedState({
    required this.userModel,
  });
}

final class ProfileLogOutState extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  final AuthErrorCode errorCode;
  final String? errorDescriptionMessage;

  ProfileErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
