abstract interface class LocalDatabase {
  Future<Map<String, dynamic>> getById({
    required String table,
    required String idColumn,
    required dynamic id,
  });

  Future<List<Map<String, dynamic>>> getAll({
    required String table,
  });

  Future<List<Map<String, dynamic>>> getByColumn({
    required String table,
    required String column,
    required dynamic columnValues,
  });

  Future<int> insert({
    required String table,
    required Map<String, dynamic> values,
  });

  Future<int> update({
    required String table,
    required Map<String, dynamic> values,
    required String idColumn,
    required dynamic id,
  });

  Future<bool> verifyItemIsAlreadyInserted({
    required String table,
    required String column,
    required dynamic columnValue,
  });

  Future<int> delete({
    required String table,
    required String idColumn,
    required dynamic id,
  });
}
