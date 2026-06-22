import 'package:bookify/src/data/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/domain/models/category_model.dart';
import 'package:bookify/src/data/repositories/category_repository/categories_repository_impl.dart';
import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final categoriesRepository = CategoriesRepositoryImpl(localDatabase);

  group('Test normal CRUD category without error ||', () {
    test('insert new category', () async {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenAnswer((_) async => 1);

      final categoryId = await categoriesRepository.insert(
        categoryModel: CategoryModel(name: 'Fiction'),
      );

      expect(categoryId, equals(1));
    });

    test('get actual category id by name', () async {
      when(
        () => localDatabase.getItemsByColumn(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenAnswer(
        (_) async => [
          {'id': 1, 'name': 'Fiction'},
        ],
      );

      final categoryId = await categoriesRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(1));
    });

    test('get -1 when is a empty list', () async {
      when(
        () => localDatabase.getItemsByColumn(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenAnswer((_) async => []);

      final categoryId = await categoriesRepository.getCategoryIdByColumnName(
        categoryName: 'Fiction',
      );

      expect(categoryId, equals(-1));
    });

    test('get category by Id', () async {
      when(
        () => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => {'id': 1, 'name': 'Fiction'});

      final categoryModel = await categoriesRepository.getCategoryById(id: 1);

      expect(categoryModel.id, equals(1));
      expect(categoryModel.name, equals('Fiction'));
    });

    test('delete category by Id', () async {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => 1);

      final rowDeleted = await categoriesRepository.deleteCategoryById(id: 1);
      expect(rowDeleted, equals(1));
    });
  });

  group('Test normal CRUD category with error ||', () {
    test('insert new category', () async {
      when(
        () => localDatabase.insert(
          table: any(named: 'table'),
          values: any(named: 'values'),
        ),
      ).thenThrow(
        const LocalDatabaseException(
          LocalDatabaseErrorCode.unknown,
          descriptionMessage: 'Error on database',
        ),
      );

      expect(
        () async => await categoriesRepository.insert(
          categoryModel: CategoryModel(name: 'Fiction'),
        ),
        throwsA(
          isA<LocalDatabaseException>()
              .having(
                (e) => e.code,
                'code',
                LocalDatabaseErrorCode.unknown,
              )
              .having(
                (e) => e.descriptionMessage,
                'descriptionMessage',
                'Error on database',
              ),
        ),
      );
    });

    test('get actual category id by name', () async {
      when(
        () => localDatabase.getItemsByColumn(
          table: any(named: 'table'),
          column: any(named: 'column'),
          columnValues: any(named: 'columnValues'),
        ),
      ).thenAnswer((_) async => [{}]);

      expect(
        () async => await categoriesRepository.getCategoryIdByColumnName(
          categoryName: 'Fiction',
        ),
        throwsA(
          isA<LocalDatabaseException>().having(
            (e) => e.code,
            'code',
            LocalDatabaseErrorCode.conversionFailed,
          ),
        ),
      );
    });

    test('get category by Id', () async {
      when(
        () => localDatabase.getItemById(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenAnswer((_) async => {'id': '1', 'name': 'Fiction'});

      expect(
        () async => await categoriesRepository.getCategoryById(id: 1),
        throwsA(
          isA<LocalDatabaseException>().having(
            (e) => e.code,
            'code',
            LocalDatabaseErrorCode.conversionFailed,
          ),
        ),
      );
    });

    test('delete category by Id', () async {
      when(
        () => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'),
        ),
      ).thenThrow(
        const LocalDatabaseException(
          LocalDatabaseErrorCode.unknown,
          descriptionMessage: 'Error on database',
        ),
      );

      expect(
        () async => await categoriesRepository.deleteCategoryById(id: 1),
        throwsA(
          isA<LocalDatabaseException>()
              .having(
                (e) => e.code,
                'code',
                LocalDatabaseErrorCode.unknown,
              )
              .having(
                (e) => e.descriptionMessage,
                'descriptionMessage',
                'Error on database',
              ),
        ),
      );
    });
  });
}
