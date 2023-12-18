import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/category_repository/category_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final categoryRepository = CategoryRepositoryImpl(localDatabase);

  group('Test normal CRUD category without error ||', () {
    test('insert new category', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final categoryId = await categoryRepository.insert(
        categoryModel: CategoryModel(name: 'Fiction'),
      );

      expect(categoryId, equals(1));
    });

    test('get actual category id by name', () async {
      when(() => localDatabase.getByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => [
            {'id': 1, 'name': 'Fiction'}
          ]);

      final categoryId = await categoryRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(1));
    });

    test('get -1 when is a empty list', () async {
      when(() => localDatabase.getByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => []);

      final categoryId = await categoryRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(-1));
    });

    test('get category by Id', () async {
      when(() => localDatabase.getById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': 1, 'name': 'Fiction'});

      final categoryModel = await categoryRepository.getCategoryById(id: 1);

      expect(categoryModel.id, equals(1));
      expect(categoryModel.name, equals('Fiction'));
    });

    test('delete category by Id', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => 1);

      final rowDeleted = await categoryRepository.deleteCategoryById(id: 1);
      expect(rowDeleted, equals(1));
    });
  });
}
