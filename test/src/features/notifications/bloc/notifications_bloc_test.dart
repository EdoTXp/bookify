import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/features/notifications/bloc/notifications_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NotificationsServiceMock extends Mock implements NotificationsService {}

void main() {
  final notificationsService = NotificationsServiceMock();
  late NotificationsBloc notificationsBloc;

  setUp(
    () {
      notificationsBloc = NotificationsBloc(
        notificationsService,
      );
    },
  );

  group('Test Notifications Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => notificationsBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotNotificationsEvent work',
      build: () => notificationsBloc,
      setUp: () => when(
        () => notificationsService.getNotifications(),
      ).thenAnswer(
        (_) async => [
          CustomNotificationModel(
            id: 1,
            notificationChannel: NotificationChannel.loanChannel,
            title: 'title',
            body: 'body',
            scheduledDate: DateTime.now(),
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        GotNotificationsEvent(),
      ),
      verify: (_) => verify(
        () => notificationsService.getNotifications(),
      ).called(1),
      expect: () => [
        isA<NotificationsLoadingState>(),
        isA<NotificationsLoadedState>(),
      ],
    );

    blocTest(
      'Test GotNotificationsEvent work when notifications is empty',
      build: () => notificationsBloc,
      setUp: () => when(
        () => notificationsService.getNotifications(),
      ).thenAnswer(
        (_) async => [],
      ),
      act: (bloc) => bloc.add(
        GotNotificationsEvent(),
      ),
      verify: (_) => verify(
        () => notificationsService.getNotifications(),
      ).called(1),
      expect: () => [
        isA<NotificationsLoadingState>(),
        isA<NotificationEmptyState>(),
      ],
    );

    blocTest(
      'Test GotNotificationsEvent work when throw Generic Exception',
      build: () => notificationsBloc,
      setUp: () => when(
        () => notificationsService.getNotifications(),
      ).thenThrow(Exception('generic error')),
      act: (bloc) => bloc.add(
        GotNotificationsEvent(),
      ),
      verify: (_) => verify(
        () => notificationsService.getNotifications(),
      ).called(1),
      expect: () => [
        isA<NotificationsLoadingState>(),
        isA<NotificationErrorState>(),
      ],
    );
  });
}
