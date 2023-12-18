import 'package:bookify/src/shared/models/category_model.dart';

abstract interface class CategoryRepository {
 Future<CategoryModel> getCategoryById({required int id});
  Future<int> insert({required CategoryModel categoryModel});
  Future<int> getCategoryIdByColumnName({required String categoryName});
  Future<int> deleteCategoryById({required int id});
}