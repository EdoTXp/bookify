import 'package:bookify/src/core/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsService _notificationsService;

  NotificationsBloc(
    this._notificationsService,
  ) : super(NotificationsLoadingState()) {
    on<GotNotificationsEvent>(_gotNotificationsEvent);
  }

  Future<void> _gotNotificationsEvent(
    GotNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      emit(NotificationsLoadingState());

      final notifications = await _notificationsService.getNotifications();

      if (notifications.isEmpty) {
        emit(NotificationEmptyState());
        return;
      }

      emit(
        NotificationsLoadedState(
          notifications: notifications,
        ),
      );
    } on Exception catch (e) {
      emit(
        NotificationErrorState(
            errorMessage: 'Erro inesperado: ${e.toString()}'),
      );
    }
  }
}
