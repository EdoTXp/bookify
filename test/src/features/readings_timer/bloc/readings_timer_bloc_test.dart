import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:bookify/src/features/readings_timer/bloc/readings_timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserHourTimeRepositoryMock extends Mock
    implements UserHourTimeRepository {}

void main() {
  const userHourTimeModel = UserHourTimeModel(
    repeatHourTimeType: RepeatHourTimeType.daily,
    startingHour: 8,
    startingMinute: 0,
    endingHour: 8,
    endingMinute: 30,
  );

  final userHourTimeRepository = UserHourTimeRepositoryMock();
  late ReadingsTimerBloc readingsTimerBloc;

  setUp(
    () {
      readingsTimerBloc = ReadingsTimerBloc(
        userHourTimeRepository,
      );
    },
  );

  group('Test ReadingsTimer Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => readingsTimerBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotReadingsUserTimerEvent work',
      build: () => readingsTimerBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenAnswer(
        (_) async => userHourTimeModel,
      ),
      act: (bloc) => bloc.add(GotReadingsUserTimerEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ReadingsTimerLoadingState>(),
        isA<ReadingsTimerLoadedState>(),
      ],
    );

    blocTest(
      'Test GotReadingsUserTimerEvent work when userHourTime is null',
      build: () => readingsTimerBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenAnswer(
        (_) async => null,
      ),
      act: (bloc) => bloc.add(GotReadingsUserTimerEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ReadingsTimerLoadingState>(),
        isA<ReadingsTimerEmptyState>(),
      ],
    );

    blocTest(
      'Test GotReadingsUserTimerEvent work when throw Storage Exception',
      build: () => readingsTimerBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenThrow(const StorageException('Error on storage')),
      act: (bloc) => bloc.add(GotReadingsUserTimerEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ReadingsTimerLoadingState>(),
        isA<ReadingsTimerErrorState>(),
      ],
    );

    blocTest(
      'Test GotReadingsUserTimerEvent work when throw Generic Exception',
      build: () => readingsTimerBloc,
      setUp: () => when(
        () => userHourTimeRepository.getUserHourTime(),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(GotReadingsUserTimerEvent()),
      verify: (_) => verify(
        () => userHourTimeRepository.getUserHourTime(),
      ).called(1),
      expect: () => [
        isA<ReadingsTimerLoadingState>(),
        isA<ReadingsTimerErrorState>(),
      ],
    );
  });
}
