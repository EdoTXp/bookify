import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as category_table;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/category_repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final LocalDatabase _database;
  final _categoryTableName = category_table.categorytableName;

  CategoryRepositoryImpl(this._database);

  @override
  Future<CategoryModel> getCategoryById({required int id}) async {
    final categoryMap = await _database.getById(
      table: _categoryTableName,
      idColumn: 'id',
      id: id,
    );

    final categoryModel = CategoryModel.fromMap(categoryMap);
    return categoryModel;
  }

  /// Try looking to see if the book is already included.
  /// From the search, it returns the ID. Returns [-1] if the search found no category.
  @override
  Future<int> getCategoryIdByColumnName({required String categoryName}) async {
    final categoryMap = await _database.getByColumn(
      table: _categoryTableName,
      column: 'name',
      columnValues: categoryName,
    );

    if (categoryMap.isNotEmpty) {
      final actualAuthorId = categoryMap.last['id'] as int;
      return actualAuthorId;
    }

    return -1;
  }

  @override
  Future<int> insert({required CategoryModel categoryModel}) async {
    final categoryId = await _database.insert(
      table: _categoryTableName,
      values: categoryModel.toMap(),
    );

    return categoryId;
  }

  @override
  Future<int> deleteCategoryById({required int id}) async {
    final deletedRow = await _database.delete(
      table: _categoryTableName,
      idColumn: 'id',
      id: id,
    );

    return deletedRow;
  }
}
