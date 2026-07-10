import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/domain/models/user_hour_time_model.dart';
import 'package:bookify/src/data/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/domain/models/custom_notification_model.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service.dart';
import 'package:bookify/src/features/programming_reading/bloc/programming_reading_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserReadingTimeRepositoryMock extends Mock
    implements UserHourTimeRepository {}

class NotificationsServiceMock extends Mock implements NotificationsService {}

void main() {
  const userHourTime = UserHourTimeModel(
    repeatHourTimeType: RepeatHourTimeType.daily,
    startingHour: 10,
    startingMinute: 30,
    endingHour: 11,
    endingMinute: 0,
  );

  final userHourTimeRepository = UserReadingTimeRepositoryMock();
  final notificationsService = NotificationsServiceMock();
  late ProgrammingReadingBloc programmingReadingBloc;

  setUp(
    () {
      registerFallbackValue(
        CustomNotificationModel(
          id: 1,
          notificationChannel: NotificationChannel.readChannel,
          title: 'title',
          body: 'body',
        ),
      );
      registerFallbackValue(RepeatHourTimeType.daily);

      registerFallbackValue(DateTime.now());

      programmingReadingBloc = ProgrammingReadingBloc(
        userHourTimeRepository,
        notificationsService,
      );
    },
  );

  group('Test ProgrammingReading Bloc', () {
    blocTest(
      ' Initial state is empty',
      build: () => programmingReadingBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotHourTimeEvent work',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.getUserHourTime(),
          ).thenAnswer(
            (_) async => userHourTime,
          ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingLoadedState>(),
      ],
    );

    blocTest(
      'Test GotHourTimeEvent work when throw StorageException',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.getUserHourTime(),
          ).thenThrow(
            const StorageException(
              StorageErrorCode.invalidValue,
              descriptionMessage: 'Error on storage',
            ),
          ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingErrorState>(),
      ],
    );

    blocTest(
      'Test GotHourTimeEvent work  when throw Generic Exception',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.getUserHourTime(),
          ).thenThrow(
            Exception('Generic Error'),
          ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work',
      build: () => programmingReadingBloc,
      setUp: () {
        when(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () =>
              notificationsService.periodicallyShowNotificationWithSpecificDate(
                notification: any(named: 'notification'),
                repeatType: any(named: 'repeatType'),
                scheduledDate: any(named: 'scheduledDate'),
              ),
        ).thenAnswer(
          (_) async {},
        );
      },
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
          readingTimeNotificationTitle: 'notificationTitle',
          readingTimeNotificationBody: 'notificationBody',
          notificationPayloadRoute: 'notificationPayloadRoute',
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verify(
          () =>
              notificationsService.periodicallyShowNotificationWithSpecificDate(
                notification: any(named: 'notification'),
                repeatType: any(named: 'repeatType'),
                scheduledDate: any(named: 'scheduledDate'),
              ),
        ).called(1);
      },
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when userHourTimeInserted == 0',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.setUserHourTime(
              userHourTime: userHourTime,
            ),
          ).thenAnswer(
            (_) async => 0,
          ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
          readingTimeNotificationTitle: 'notificationTitle',
          readingTimeNotificationBody: 'notificationBody',
          notificationPayloadRoute: 'notificationPayloadRoute',
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () =>
              notificationsService.periodicallyShowNotificationWithSpecificDate(
                notification: any(named: 'notification'),
                repeatType: any(named: 'repeatType'),
                scheduledDate: any(named: 'scheduledDate'),
              ),
        );
      },
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when throw StorageException',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.setUserHourTime(
              userHourTime: userHourTime,
            ),
          ).thenThrow(
            const StorageException(
              StorageErrorCode.invalidValue,
              descriptionMessage: 'Error on storage',
            ),
          ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
          readingTimeNotificationTitle: 'notificationTitle',
          readingTimeNotificationBody: 'notificationBody',
          notificationPayloadRoute: 'notificationPayloadRoute',
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () =>
              notificationsService.periodicallyShowNotificationWithSpecificDate(
                notification: any(named: 'notification'),
                repeatType: any(named: 'repeatType'),
                scheduledDate: any(named: 'scheduledDate'),
              ),
        );
      },
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when throw Generic Exception',
      build: () => programmingReadingBloc,
      setUp: () =>
          when(
            () => userHourTimeRepository.setUserHourTime(
              userHourTime: userHourTime,
            ),
          ).thenThrow(
            Exception('Generic Error'),
          ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
          readingTimeNotificationTitle: 'notificationTitle',
          readingTimeNotificationBody: 'notificationBody',
          notificationPayloadRoute: 'notificationPayloadRoute',
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () =>
              notificationsService.periodicallyShowNotificationWithSpecificDate(
                notification: any(named: 'notification'),
                repeatType: any(named: 'repeatType'),
                scheduledDate: any(named: 'scheduledDate'),
              ),
        );
      },
      expect: () => [
        isA<ProgrammingReadingLoadingState>(),
        isA<ProgrammingReadingErrorState>(),
      ],
    );
  });

  blocTest(
    'Test RemovedNotificationHourTimeEvent work',
    build: () => programmingReadingBloc,
    setUp: () {
      when(
        () => userHourTimeRepository.removeUserHourTime(),
      ).thenAnswer(
        (_) async => 1,
      );

      when(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).thenAnswer(
        (_) async {},
      );
    },
    act: (bloc) => bloc.add(RemovedNotificationHourTimeEvent()),
    verify: (_) {
      verify(
        () => userHourTimeRepository.removeUserHourTime(),
      ).called(1);

      verify(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).called(1);
    },
    expect: () => [
      isA<ProgrammingReadingLoadingState>(),
      isA<ProgrammingReadingRemovedNotificationState>(),
    ],
  );

  blocTest(
    'Test RemovedNotificationHourTimeEvent work when throw StorageErrorCode',
    build: () => programmingReadingBloc,
    setUp: () {
      when(
        () => userHourTimeRepository.removeUserHourTime(),
      ).thenAnswer(
        (_) async => 0,
      );
    },
    act: (bloc) => bloc.add(RemovedNotificationHourTimeEvent()),
    verify: (_) {
      verify(
        () => userHourTimeRepository.removeUserHourTime(),
      ).called(1);

      verifyNever(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      );
    },
    expect: () => [
      isA<ProgrammingReadingLoadingState>(),
      isA<ProgrammingReadingErrorState>(),
    ],
  );

  blocTest(
    'Test RemovedNotificationHourTimeEvent  work when throw Generic Exception',
    build: () => programmingReadingBloc,
    setUp: () {
      when(
        () => userHourTimeRepository.removeUserHourTime(),
      ).thenAnswer(
        (_) async => 1,
      );

      when(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).thenThrow(
        Exception('Generic Error'),
      );
    },
    act: (bloc) => bloc.add(RemovedNotificationHourTimeEvent()),
    verify: (_) {
      verify(
        () => userHourTimeRepository.removeUserHourTime(),
      ).called(1);

      verify(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).called(1);
    },
    expect: () => [
      isA<ProgrammingReadingLoadingState>(),
      isA<ProgrammingReadingErrorState>(),
    ],
  );
}
