part of 'notifications_bloc.dart';

sealed class NotificationsState {}

final class NotificationsLoadingState extends NotificationsState {}

final class NotificationEmptyState extends NotificationsState {}

final class NotificationsLoadedState extends NotificationsState {
  final List<CustomNotificationModel> notifications;

  NotificationsLoadedState({
    required this.notifications,
  });
}

final class NotificationErrorState extends NotificationsState {
  final PlatformErrorCode errorCode;
  final String? errorDescriptionMessage;

  NotificationErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
