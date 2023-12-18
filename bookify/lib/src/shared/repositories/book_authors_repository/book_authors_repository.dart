abstract interface class BookAuthorsRepository {
  Future<List<Map<String, dynamic>>> getRelationshipsById({
    required String bookId,
  });
  Future<int> insert({required String bookId, required int authorId});
  Future<int> delete({required String bookId});
}
