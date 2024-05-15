import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final categoriesRepository = CategoriesRepositoryImpl(localDatabase);

  group('Test normal CRUD category without error ||', () {
    test('insert new category', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final categoryId = await categoriesRepository.insert(
        categoryModel: CategoryModel(name: 'Fiction'),
      );

      expect(categoryId, equals(1));
    });

    test('get actual category id by name', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => [
            {'id': 1, 'name': 'Fiction'}
          ]);

      final categoryId = await categoriesRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(1));
    });

    test('get -1 when is a empty list', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => []);

      final categoryId = await categoriesRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(-1));
    });

    test('get category by Id', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': 1, 'name': 'Fiction'});

      final categoryModel = await categoriesRepository.getCategoryById(id: 1);

      expect(categoryModel.id, equals(1));
      expect(categoryModel.name, equals('Fiction'));
    });

    test('delete category by Id', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => 1);

      final rowDeleted = await categoriesRepository.deleteCategoryById(id: 1);
      expect(rowDeleted, equals(1));
    });
  });

  group('Test normal CRUD category with error ||', () {
    test('insert new category', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await categoriesRepository.insert(
          categoryModel: CategoryModel(name: 'Fiction'),
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get actual category id by name', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => [{}]);

      expect(
        () async => await categoriesRepository.getCategoryIdByColumnName(
          categoryName: 'Fiction',
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('get category by Id', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': '1', 'name': 'Fiction'});

      expect(
        () async => await categoriesRepository.getCategoryById(id: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('delete category by Id', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await categoriesRepository.deleteCategoryById(id: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
