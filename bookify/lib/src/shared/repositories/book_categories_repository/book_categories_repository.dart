abstract interface class BookCategoriesRepository {
  Future<List<Map<String, dynamic>>> getRelationshipsById(
      {required String bookId});
  Future<int> insert({required String bookId, required int categoryId});
  Future<int> delete({required String bookId});
}
