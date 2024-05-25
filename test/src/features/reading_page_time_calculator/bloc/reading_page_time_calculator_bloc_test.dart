import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:bookify/src/features/reading_page_time_calculator/bloc/reading_page_time_calculator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserPageReadingTimeRepositoryMock extends Mock
    implements UserPageReadingTimeRepository {}

void main() {
  const userPageReadingTime = UserPageReadingTimeModel(
    pageReadingTimeSeconds: 600,
  );
  final userPageReadingTimeRepository = UserPageReadingTimeRepositoryMock();
  late ReadingPageTimeCalculatorBloc readingPageTimeCalculatorbloc;

  setUp(() {
    readingPageTimeCalculatorbloc = ReadingPageTimeCalculatorBloc(
      userPageReadingTimeRepository,
    );
  });

  group('Test ReadingPageTimeCalculator Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => readingPageTimeCalculatorbloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test InsertedReadingPageTimeEvent work',
      build: () => readingPageTimeCalculatorbloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).thenAnswer(
        (_) async => 1,
      ),
      act: (bloc) => bloc.add(
        InsertedReadingPageTimeEvent(
          readingPageTime: 600,
        ),
      ),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingPageTimeCalculatorLoadingState>(),
        isA<ReadingPageTimeCalculatorInsertedState>(),
      ],
    );

    blocTest(
      'Test InsertedReadingPageTimeEvent work when userPageReadingTimeInserted == 0',
      build: () => readingPageTimeCalculatorbloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).thenAnswer(
        (_) async => 0,
      ),
      act: (bloc) => bloc.add(
        InsertedReadingPageTimeEvent(
          readingPageTime: 600,
        ),
      ),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingPageTimeCalculatorLoadingState>(),
        isA<ReadingPageTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedReadingPageTimeEvent work when throw StorageException',
      build: () => readingPageTimeCalculatorbloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).thenThrow(
        const StorageException('Error on storage'),
      ),
      act: (bloc) => bloc.add(
        InsertedReadingPageTimeEvent(
          readingPageTime: 600,
        ),
      ),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingPageTimeCalculatorLoadingState>(),
        isA<ReadingPageTimeCalculatorErrorState>(),
      ],
    );

    blocTest(
      'Test InsertedReadingPageTimeEvent work when throw Generic Exception',
      build: () => readingPageTimeCalculatorbloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(
        InsertedReadingPageTimeEvent(
          readingPageTime: 600,
        ),
      ),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
      ).called(1),
      expect: () => [
        isA<ReadingPageTimeCalculatorLoadingState>(),
        isA<ReadingPageTimeCalculatorErrorState>(),
      ],
    );
  });
}
