part of 'user_notification_cubit.dart';

@immutable
sealed class UserNotificationState {}

final class UserNotificationLoadingState extends UserNotificationState {}

final class UserNotificationLoadedState extends UserNotificationState {}

final class UserNotificationErrorState extends UserNotificationState {
  final String errorMessage;

  UserNotificationErrorState({
    required this.errorMessage,
  });
}
