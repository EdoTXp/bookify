import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_theme_repository/user_theme_repository_impl.dart';
import 'package:bookify/src/core/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  final storage = StorageMock();
  final userThemeRepository = UserThemeRepositoryImpl(storage: storage);

  group('Test normal crud without error', () {
    test('Test get ThemeMode', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer((_) async => 1);

      final theme = await userThemeRepository.getThemeMode();

      expect(
        theme,
        equals(ThemeMode.light),
      );
    });

    test('Test set ThemeMode', () async {
      when(
        () => storage.insertStorage(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => 1);

      final themeInserted = await userThemeRepository.setThemeMode(
        themeMode: ThemeMode.light,
      );

      expect(
        themeInserted,
        equals(1),
      );
    });
  });

  group('Test normal crud with error', () {
    test('Test get ThemeMode with TypeError', () async {
      when(
        () => storage.getStorage(
          key: any(named: 'key'),
        ),
      ).thenAnswer((_) async => '1');

      expect(
        () async => await userThemeRepository.getThemeMode(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.invalidValue &&
              e.descriptionMessage == 'Impossible to convert theme mode.',
        ),
      );
    });

    test('Test get ThemeMode with Storage Exception', () async {
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
        () async => await userThemeRepository.getThemeMode(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.readFailed &&
              e.descriptionMessage == 'Storage error',
        ),
      );
    });

    test('Test set ThemeMode with Storage Exception', () async {
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
        () async => await userThemeRepository.setThemeMode(
          themeMode: ThemeMode.light,
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
