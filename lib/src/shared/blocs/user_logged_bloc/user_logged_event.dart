part of 'user_logged_bloc.dart';

sealed class UserLoggedEvent {}

final class CheckedAuthStatusEvent extends UserLoggedEvent {}
