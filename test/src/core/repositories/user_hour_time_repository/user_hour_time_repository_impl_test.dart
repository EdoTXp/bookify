import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/enums/repeat_hour_time_type.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository_impl.dart';
import 'package:bookify/src/core/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  const userHourTime = UserHourTimeModel(
    repeatHourTimeType: RepeatHourTimeType.daily,
    startingHour: 10,
    startingMinute: 30,
    endingHour: 11,
    endingMinute: 0,
  );

  final storage = StorageMock();
  final userHourTimeRepository = UserHourTimeRepositoryImpl(
    storage: storage,
  );
  group('Test normal crud without error', () {
    test('Test get UserHourTime', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer(
        (_) async => userHourTime.toJson(),
      );

      final userHourTimeModel = await userHourTimeRepository.getUserHourTime();

      expect(
        userHourTimeModel,
        equals(userHourTime),
      );
    });

    test('Test get UserHourTime when json is null', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer(
        (_) async => null,
      );

      final userHourTimeModel = await userHourTimeRepository.getUserHourTime();

      expect(
        userHourTimeModel,
        equals(equals(null)),
      );
    });

    test('Test set UserHourTime', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer(
        (_) async => 1,
      );

      final userHourTimeModel = await userHourTimeRepository.setUserHourTime(
        userHourTime: userHourTime,
      );

      expect(
        userHourTimeModel,
        equals(1),
      );
    });
  });

  group('Test normal crud with error', () {
    test('Test get UserHourTime with TypeError', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer(
        (_) async => '1',
      );

      expect(
        () async => await userHourTimeRepository.getUserHourTime(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.message == 'impossível converter a hora de leitura.',
        ),
      );
    });

    test('Test get UserHourTime with Storage Exception', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await userHourTimeRepository.getUserHourTime(),
        throwsA(
          (Exception e) =>
              e is StorageException && e.message == 'Storage error',
        ),
      );
    });

    test('Test set UserHourTime with Storage Exception', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(const StorageException('Storage error'));

      expect(
        () async => await userHourTimeRepository.setUserHourTime(
          userHourTime: userHourTime,
        ),
        throwsA(
          (Exception e) =>
              e is StorageException && e.message == 'Storage error',
        ),
      );
    });
  });
}
