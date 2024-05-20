import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/services/storage_services/storage_services.dart';
import 'package:bookify/src/core/storage/storage.dart';

class StorageServicesImpl implements StorageServices {
  final Storage _storage;

  StorageServicesImpl({
    required Storage storage,
  }) : _storage = storage;

  @override
  Future<int> clearStorage() async {
    try {
      final clearStorage = await _storage.deleteAllStorage();
      return clearStorage;
    } on StorageException {
      rethrow;
    }
  }
}
