import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/reading_model.dart';
import 'package:bookify/src/shared/repositories/reading_repository/reading_repository.dart';
import 'package:bookify/src/shared/services/reading_services/reading_service.dart';

class ReadingServiceImpl implements ReadingService {
  final ReadingRepository _readingRepository;

  ReadingServiceImpl(this._readingRepository);

  @override
  Future<List<ReadingModel>> getAll() async {
    try {
      final readingsModel = await _readingRepository.getAll();
      return readingsModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<ReadingModel> getById({required int readingId}) async {
    try {
      final readingModel = await _readingRepository.getById(
        readingId: readingId,
      );
      return readingModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<ReadingModel>> getReadingsByBookTitle({
    required String title,
  }) async {
    try {
      final readingModel = await _readingRepository.getReadingsByBookTitle(
        title: title,
      );
      return readingModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countReadings() async {
    try {
      final readingsCount = await _readingRepository.countReadings();
      return readingsCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required ReadingModel readingModel}) async {
    try {
      final newReadingId = await _readingRepository.insert(
        readingModel: readingModel,
      );

      return newReadingId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> update({required ReadingModel readingModel}) async {
    try {
      final rowUpdated = await _readingRepository.update(
        readingModel: readingModel,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int readingId}) async {
    try {
      final rowDeleted = await _readingRepository.delete(
        readingId: readingId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
