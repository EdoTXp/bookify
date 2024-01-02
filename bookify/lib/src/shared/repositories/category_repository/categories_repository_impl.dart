import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as category_table;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final LocalDatabase _database;
  final _categoryTableName = category_table.categorytableName;

  CategoriesRepositoryImpl(this._database);

  @override
  Future<CategoryModel> getCategoryById({required int id}) async {
    try {
      final categoryMap = await _database.getItemById(
        table: _categoryTableName,
        idColumn: 'id',
        id: id,
      );

      final categoryModel = CategoryModel.fromMap(categoryMap);
      return categoryModel;
    } on TypeError {
      throw LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  /// Try looking to see if the book is already included.
  /// From the search, it returns the ID. Returns [-1] if the search found no category.
  @override
  Future<int> getCategoryIdByColumnName({required String categoryName}) async {
    try {
      final categoryMap = await _database.getItemByColumn(
        table: _categoryTableName,
        column: 'name',
        columnValues: categoryName,
      );

      if (categoryMap.isNotEmpty) {
        final actualAuthorId = categoryMap.last['id'] as int;
        return actualAuthorId;
      }

      return -1;
    } on TypeError {
      throw LocalDatabaseException('Impossível converter o dado do database');
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required CategoryModel categoryModel}) async {
    try {
      final categoryId = await _database.insert(
        table: _categoryTableName,
        values: categoryModel.toMap(),
      );

      return categoryId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteCategoryById({required int id}) async {
    try {
      final deletedRow = await _database.delete(
        table: _categoryTableName,
        idColumn: 'id',
        id: id,
      );

      return deletedRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
