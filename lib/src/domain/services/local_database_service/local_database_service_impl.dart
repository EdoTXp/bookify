import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/data/database/local_database.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service.dart';

class LocalDatabaseServiceImpl implements LocalDatabaseService {
  final LocalDatabase _database;

  LocalDatabaseServiceImpl({required LocalDatabase database})
    : _database = database;

  @override
  Future<void> deleteDatabase() async {
    try {
      await _database.deleteDatabase();
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
