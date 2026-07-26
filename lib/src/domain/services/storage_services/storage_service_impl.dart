import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service.dart';
import 'package:bookify/src/data/storage/storage.dart';

class StorageServiceImpl implements StorageService {
  final Storage _storage;

  StorageServiceImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<int> clearAllStorage() async {
    try {
      final clearStorage = await _storage.deleteAllStorage();
      return clearStorage;
    } on StorageException {
      rethrow;
    }
  }
}
