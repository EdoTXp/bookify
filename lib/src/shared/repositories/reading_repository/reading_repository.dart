import 'package:bookify/src/shared/models/reading_model.dart';

abstract interface class ReadingRepository {
  Future<List<ReadingModel>> getAll();
  Future<List<ReadingModel>> getReadingsByBookTitle({required String title});
  Future<ReadingModel> getById({required int readingId});
  Future<int> insert({required ReadingModel readingModel});
  Future<int> update({required ReadingModel readingModel});
  Future<int> delete({required int readingId});
}
