import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/features/hour_time_calculator/bloc/hour_time_calculator_bloc.dart';
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
  late HourTimeCalculatorBloc hourTimeCalculatorBloc;

  setUp(
    () {
      registerFallbackValue(NotificationChannel.readChannel);
      registerFallbackValue(RepeatIntervalType.daily);

      hourTimeCalculatorBloc = HourTimeCalculatorBloc(
        userHourTimeRepository,
        notificationsService,
      );
    },
  );

  group('Test HourTimeCalculator Bloc', () {
    blocTest(
      ' Initial state is empty',
      build: () => hourTimeCalculatorBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotHourTimeEvent work',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenAnswer(
        (_) async => userHourTime,
      ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorLoadedState>(),
      ],
    );

    blocTest(
      'Test GotHourTimeEvent work when throw StorageException',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenThrow(
        const StorageException('Error on storage'),
      ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test GotHourTimeEvent work  when throw Generic Exception',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(GotHourTimeEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work',
      build: () => hourTimeCalculatorBloc,
      setUp: () {
        when(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).thenAnswer(
          (_) async => 1,
        );

        when(
          () => notificationsService.periodicallyShowNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationChannel: any(named: 'notificationChannel'),
            repeatType: any(named: 'repeatType'),
          ),
        ).thenAnswer(
          (_) async {},
        );
      },
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verify(
          () => notificationsService.periodicallyShowNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationChannel: any(named: 'notificationChannel'),
            repeatType: any(named: 'repeatType'),
          ),
        ).called(1);
      },
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when userHourTimeInserted == 0',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.setUserHourTime(
          userHourTime: userHourTime,
        ),
      ).thenAnswer(
        (_) async => 0,
      ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () => notificationsService.periodicallyShowNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationChannel: any(named: 'notificationChannel'),
            repeatType: any(named: 'repeatType'),
          ),
        );
      },
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when throw StorageException',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.setUserHourTime(
          userHourTime: userHourTime,
        ),
      ).thenThrow(
        const StorageException('Error on storage'),
      ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () => notificationsService.periodicallyShowNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationChannel: any(named: 'notificationChannel'),
            repeatType: any(named: 'repeatType'),
          ),
        );
      },
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedHourTimeEvent work when throw Generic Exception',
      build: () => hourTimeCalculatorBloc,
      setUp: () => when(
        () => userHourTimeRepository.setUserHourTime(
          userHourTime: userHourTime,
        ),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        InsertedHourTimeEvent(
          userHourTimeModel: userHourTime,
        ),
      ),
      verify: (_) {
        verify(
          () => userHourTimeRepository.setUserHourTime(
            userHourTime: userHourTime,
          ),
        ).called(1);

        verifyNever(
          () => notificationsService.periodicallyShowNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            notificationChannel: any(named: 'notificationChannel'),
            repeatType: any(named: 'repeatType'),
          ),
        );
      },
      expect: () => [
        isA<HourTimeCalculatorLoadingState>(),
        isA<HourTimeCalculatorErrorState>(),
      ],
    );
  });

  blocTest(
    'Test RemovedNotificationHourTimeEvent work',
    build: () => hourTimeCalculatorBloc,
    setUp: () => when(
      () => notificationsService.cancelNotificationById(
        id: any(named: 'id'),
      ),
    ).thenAnswer(
      (_) async {},
    ),
    act: (bloc) => bloc.add(RemovedNotificationHourTimeEvent()),
    verify: (_) {
      verify(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).called(1);
    },
    expect: () => [
      isA<HourTimeCalculatorLoadingState>(),
      isA<HourTimeCalculatorRemovedNotificationState>(),
    ],
  );

  blocTest(
    'Test RemovedNotificationHourTimeEvent  work when throw Generic Exception',
    build: () => hourTimeCalculatorBloc,
    setUp: () => when(
      () => notificationsService.cancelNotificationById(
        id: any(named: 'id'),
      ),
    ).thenThrow(
      Exception('Generic Error'),
    ),
    act: (bloc) => bloc.add(RemovedNotificationHourTimeEvent()),
    verify: (_) {
      verify(
        () => notificationsService.cancelNotificationById(
          id: any(named: 'id'),
        ),
      ).called(1);
    },
    expect: () => [
      isA<HourTimeCalculatorLoadingState>(),
      isA<HourTimeCalculatorErrorState>(),
    ],
  );
}
