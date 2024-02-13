enum OrderByType {
  ascendant,
  descendant;

  String orderToString() {
    switch (this) {
      case OrderByType.ascendant:
        return 'ASC';
      case OrderByType.descendant:
        return 'DESC';
    }
  }
}

/// An abstract interface class representing a local database.
///
/// This class defines the methods that any local database implementation
/// should have. These methods include basic CRUD operations (Create, Read, Update, Delete),
/// as well as specific queries such as getting an item by its ID, getting all items from a table,
/// getting items by a specific column value, verifying if an item is already inserted, and deleting an item.
abstract interface class LocalDatabase {
  /// Retrieves an item from the specified table based on the provided ID.
  ///
  /// [table] The name of the table from which to retrieve the item.
  ///
  /// [idColumn] The name of the column containing the IDs of the items.
  ///
  /// [id] The ID of the item to retrieve.
  Future<Map<String, dynamic>> getItemById({
    required String table,
    required String idColumn,
    required dynamic id,
  });

  /// Retrieves all items from the specified table.
  ///
  /// [table] The name of the table from which to retrieve the items.
  Future<List<Map<String, dynamic>>> getAll({required String table});

  /// Retrieves items from the specified table based on the provided column values.
  ///
  /// [table] The name of the table from which to retrieve the items.
  ///
  /// [column] The name of the column to filter the items by.
  ///
  /// [columnValues] The values to match against the specified column.
  ///
  /// [orderBy] Choose the order the query should return: [OrderByType.descendant] or [OrderByType.ascendant].
  ///
  /// [limit] Quantity of rows that the query will return.
  Future<List<Map<String, dynamic>>> getItemsByColumn({
    required String table,
    required String column,
    required dynamic columnValues,
    OrderByType? orderBy,
    int? limit,
  });

  Future<List<Map<String, dynamic>>> researchBy({
    required String table,
    required String column,
    required String columnValues,
  });

  /// Retrieves specific columns from an item in the specified table based on the provided ID.
  ///
  /// [table] The name of the table from which to retrieve the item.
  ///
  /// [columns] The list of columns to retrieve.
  ///
  /// [idColumn] The name of the column containing the IDs of the items.
  ///
  /// [id] The ID of the item to retrieve.
  Future<Map<String, dynamic>> getColumnsById({
    required String table,
    List<String>? columns,
    required String idColumn,
    required dynamic id,
  });

  /// Inserts a new element into the specified table.
  ///
  ///[table] The name of the table to insert the element into.
  ///
  /// [values] The [Map] of column names and corresponding values to insert.
  /// This map must represent the correct names of the [table] columns.
  Future<int> insert({
    required String table,
    required Map<String, dynamic> values,
  });

  /// Updates an existing item in the specified table.
  ///
  /// [table] The name of the table to update the item in.
  ///
  /// [values] The map of column names and their corresponding values to update.
  ///
  /// [idColumn] The name of the column containing the IDs of the items.
  ///
  /// [id] The ID of the item to update.
  Future<int> update({
    required String table,
    required Map<String, dynamic> values,
    required String idColumn,
    required dynamic id,
  });

  /// Verifies if an item is already inserted in the specified table based on the provided column value.
  ///
  /// [table] The name of the table to check.
  ///
  /// [column] The name of the column to filter the items by.
  ///
  /// [columnValue] The value to match against the specified column.
  Future<bool> verifyItemIsAlreadyInserted({
    required String table,
    required String column,
    required dynamic columnValue,
  });

  /// Deletes an item from the specified table based on the provided ID.
  ///
  /// [table] The name of the table from which to delete the item.
  ///
  /// [idColumn] The name of the column containing the IDs of the items.
  ///
  /// [id] The ID of the item to delete.
  Future<int> delete({
    required String table,
    required String idColumn,
    required dynamic id,
  });

  /// Close the database to free up resources
  Future<void> closeDatabase();
}
