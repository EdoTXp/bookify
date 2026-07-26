import 'package:bookify/src/core/enums/storage_error_code.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/data/storage/storage.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class StorageMock extends Mock implements Storage {}

void main() {
  late StorageMock storage;
  late StorageServiceImpl storageService;

  setUp(() {
    storage = StorageMock();
    storageService = StorageServiceImpl(storage: storage);
  });

  group('Test delete All Storage ||', () {
    test('Test delete All Storage with success', () async {
      when(() => storage.deleteAllStorage()).thenAnswer((_) async => 1);

      final clearStorage = await storageService.clearAllStorage();

      expect(clearStorage, 1);
    });

    test('Test delete All Storage with StorageException', () async {
      when(() => storage.deleteAllStorage()).thenThrow(
        const StorageException(
          StorageErrorCode.invalidValue,
          descriptionMessage: 'DB failed',
        ),
      );

      expect(
        () async => await storageService.clearAllStorage(),
        throwsA(
          (Exception e) =>
              e is StorageException &&
              e.code == StorageErrorCode.invalidValue &&
              e.descriptionMessage == 'DB failed',
        ),
      );
    });
  });
}
