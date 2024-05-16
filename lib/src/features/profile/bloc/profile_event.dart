part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class GotUserProfileEvent extends ProfileEvent {}

final class UserLoggedOutEvent extends ProfileEvent {
  final UserModel userModel;

  UserLoggedOutEvent({
    required this.userModel,
  });
}
