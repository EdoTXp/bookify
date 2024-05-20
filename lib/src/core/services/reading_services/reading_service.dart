import 'package:bookify/src/core/models/reading_model.dart';

abstract interface class ReadingService {
  Future<List<ReadingModel>> getAll();
  Future<ReadingModel> getById({required int readingId});
  Future<List<ReadingModel>> getReadingsByBookTitle({required String title});
  Future<int> countReadings();
  Future<int> insert({required ReadingModel readingModel});
  Future<int> update({required ReadingModel readingModel});
  Future<int> delete({required int readingId});
}
