part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final UserModel userModel;

  ProfileLoadedState({
    required this.userModel,
  });
}

final class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState({
    required this.errorMessage,
  });
}
