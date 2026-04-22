import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_notification_state.dart';

class UserNotificationCubit extends Cubit<UserNotificationState> {
  final NotificationsService _notificationsService;

  UserNotificationCubit(
    this._notificationsService,
  ) : super(UserNotificationLoadingState());

  Future<void> initializeNotifications() async {
    try {
      emit(UserNotificationLoadingState());

      await _notificationsService.checkForNotifications();

      emit(UserNotificationLoadedState());
    } on Exception catch (e) {
      emit(
        UserNotificationErrorState(
          errorMessage: 'Erro ao inicializar as notificações: $e',
        ),
      );
    }
  }
}
