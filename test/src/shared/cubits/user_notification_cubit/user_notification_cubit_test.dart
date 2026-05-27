import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/cubits/user_notification_cubit/user_notification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NotificationsServiceMock extends Mock implements NotificationsService {}

void main() {
  final notificationsService = NotificationsServiceMock();
  late UserNotificationCubit userNotificationCubit;

  setUp(() {
    userNotificationCubit = UserNotificationCubit(
      notificationsService,
    );
  });

  group('Test UserNotification Cubit', () {
    blocTest(
      'Initial state is empty',
      build: () => userNotificationCubit,
      verify: (cubit) async => await cubit.close(),
      expect: () => [],
    );

    blocTest(
      'Test initializeNotifications function work',
      build: () => userNotificationCubit,
      setUp: () =>
          when(
            () => notificationsService.checkForNotifications(),
          ).thenAnswer(
            (_) async {}, // Simula il completamento di Future<void>
          ),
      act: (cubit) => cubit.initializeNotifications(),
      verify: (_) => verify(
        () => notificationsService.checkForNotifications(),
      ).called(1),
      expect: () => [
        isA<UserNotificationLoadingState>(),
        isA<UserNotificationLoadedState>(),
      ],
    );

    blocTest(
      'Test initializeNotifications function work when throw Generic Exception',
      build: () => userNotificationCubit,
      setUp: () => when(
        () => notificationsService.checkForNotifications(),
      ).thenThrow(Exception('Generic Error')),
      act: (cubit) => cubit.initializeNotifications(),
      verify: (_) => verify(
        () => notificationsService.checkForNotifications(),
      ).called(1),
      expect: () => [
        isA<UserNotificationLoadingState>(),
        isA<UserNotificationErrorState>(),
      ],
    );
  });
}
