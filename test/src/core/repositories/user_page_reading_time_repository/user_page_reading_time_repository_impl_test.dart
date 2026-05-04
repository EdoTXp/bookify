import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository_impl.dart';
import 'package:bookify/src/core/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  final storage = StorageMock();
  final userPageReadingTimeRepository = UserPageReadingTimeRepositoryImpl(
    storage: storage,
  );

  const userPageReadingTime = UserPageReadingTimeModel(
    pageReadingTimeSeconds: 600,
  );

  group('Test normal crud without error', () {
    test('get UserPageReadingTime', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer(
        (_) async => const Duration(minutes: 10).inSeconds,
      );

      final userPageReadingTime = await userPageReadingTimeRepository
          .getUserPageReadingTime();

      expect(
        userPageReadingTime.pageReadingTimeSeconds,
        equals(600),
      );
    });

    test('set UserPageReadingTime', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer(
        (_) async => 1,
      );

      final userPageReadingInserted = await userPageReadingTimeRepository
          .setUserPageReadingTime(
            userPageReadingTime: userPageReadingTime,
          );

      expect(
        userPageReadingInserted,
        equals(1),
      );
    });
  });

  group('Test normal crud with error', () {
    test('get UserPageReadingTime with TypeError', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer(
        (_) async => const Duration(minutes: 10).inSeconds.toString(),
      );

      expect(
        () async =>
            await userPageReadingTimeRepository.getUserPageReadingTime(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.invalidValue &&
              e.descriptionMessage ==
                  'Impossible to convert user page reading time.',
        ),
      );
    });

    test('get UserPageReadingTime with StorageException', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenThrow(
        StorageException(
          StorageErrorCode.readFailed,
          descriptionMessage: 'Storage error',
        ),
      );

      expect(
        () async =>
            await userPageReadingTimeRepository.getUserPageReadingTime(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.readFailed &&
              e.descriptionMessage == 'Storage error',
        ),
      );
    });

    test('set UserPageReadingTime with StorageException', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(
        StorageException(
          StorageErrorCode.writeFailed,
          descriptionMessage: 'Storage error',
        ),
      );

      expect(
        () async => await userPageReadingTimeRepository.setUserPageReadingTime(
          userPageReadingTime: userPageReadingTime,
        ),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.writeFailed &&
              e.descriptionMessage == 'Storage error',
        ),
      );
    });
  });
}
