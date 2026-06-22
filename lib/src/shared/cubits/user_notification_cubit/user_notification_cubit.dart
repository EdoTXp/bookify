import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/enums/platform_error_code.dart';
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
    } on PlatformException catch (e) {
      emit(
        UserNotificationErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        UserNotificationErrorState(
          errorCode: PlatformErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
