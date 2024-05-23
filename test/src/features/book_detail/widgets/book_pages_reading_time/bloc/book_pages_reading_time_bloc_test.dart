import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:bookify/src/features/book_detail/widgets/book_pages_reading_time/bloc/book_pages_reading_time_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class UserPageReadingTimeRepositoryMock extends Mock
    implements UserPageReadingTimeRepository {}

void main() {
  const userPageReadingTime = UserPageReadingTime(
    pageReadingTimeSeconds: 600,
  );
  final userPageReadingTimeRepository = UserPageReadingTimeRepositoryMock();

  late BookPagesReadingTimeBloc bookPagesReadingTimeBloc;

  setUp(() {
    bookPagesReadingTimeBloc = BookPagesReadingTimeBloc(
      userPageReadingTimeRepository,
    );
  });

  group('Test BookPagesReadingTime Bloc', () {
    blocTest(
      'Initial state is empty',
      build: () => bookPagesReadingTimeBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotBookPagesReadingTimeEvent work',
      build: () => bookPagesReadingTimeBloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).thenAnswer(
        (_) async => userPageReadingTime,
      ),
      act: (bloc) => bloc.add(GotBookPagesReadingTimeEvent()),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).called(1),
      expect: () => [
        isA<BookPagesReadingTimeLoadingState>(),
        isA<BookPagesReadingTimeLoadedState>(),
      ],
    );

    blocTest(
      'Test GotBookPagesReadingTimeEvent work when throw StorageException',
      build: () => bookPagesReadingTimeBloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).thenThrow(
        const StorageException('Error on storage'),
      ),
      act: (bloc) => bloc.add(GotBookPagesReadingTimeEvent()),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).called(1),
      expect: () => [
        isA<BookPagesReadingTimeLoadingState>(),
        isA<BookPagesReadingTimeErrorState>(),
      ],
    );

    blocTest(
      'Test GotBookPagesReadingTimeEvent work when throw Generic Exception',
      build: () => bookPagesReadingTimeBloc,
      setUp: () => when(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).thenThrow(
        Exception('Generic Error'),
      ),
      act: (bloc) => bloc.add(GotBookPagesReadingTimeEvent()),
      verify: (_) => verify(
        () => userPageReadingTimeRepository.getUserPageReadingTime(),
      ).called(1),
      expect: () => [
        isA<BookPagesReadingTimeLoadingState>(),
        isA<BookPagesReadingTimeErrorState>(),
      ],
    );
  });
}
