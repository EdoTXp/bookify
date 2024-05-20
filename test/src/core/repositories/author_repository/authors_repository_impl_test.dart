import 'package:bookify/src/core/database/local_database.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/repositories/author_repository/authors_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final authorsRepository = AuthorsRepositoryImpl(localDatabase);

  group('Test normal CRUD author without error ||', () {
    test('insert a new author', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final authorId = await authorsRepository.insert(
        authorModel: AuthorModel(name: 'Machado de Assis'),
      );

      expect(authorId, equals(1));
    });

    test('get actual author id by name', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => [
            {'id': 1, 'name': 'Machado de Assis'}
          ]);

      final authorId = await authorsRepository.getAuthorIdByColumnName(
        authorName: 'Machado de Assis',
      );

      expect(authorId, equals(1));
    });

    test('get -1 when is a empty list', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => []);

      final authorId = await authorsRepository.getAuthorIdByColumnName(
        authorName: 'Machado de Assis',
      );

      expect(authorId, equals(-1));
    });

    test('get author by Id', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': 1, 'name': 'Machado de Assis'});

      final authorModel = await authorsRepository.getAuthorById(id: 1);

      expect(authorModel.id, equals(1));
      expect(authorModel.name, equals('Machado de Assis'));
    });

    test('delete author by Id', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => 1);

      final rowDeleted = await authorsRepository.deleteAuthorById(id: 1);
      expect(rowDeleted, equals(1));
    });
  });

  group('Test normal CRUD author with error ||', () {
    test('insert a new author', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await authorsRepository.insert(
          authorModel: AuthorModel(name: 'Machado de Assis'),
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get actual author id by name', () async {
      when(() => localDatabase.getItemsByColumn(
            table: any(named: 'table'),
            column: any(named: 'column'),
            columnValues: any(named: 'columnValues'),
          )).thenAnswer((_) async => [{}]);

      expect(
        () async => await authorsRepository.getAuthorIdByColumnName(
          authorName: 'Machado de Assis',
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('get author by Id', () async {
      when(() => localDatabase.getItemById(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenAnswer((_) async => {'id': '1'});

      expect(
        () async => await authorsRepository.getAuthorById(id: 1),
        throwsA((Exception e) =>
            e is LocalDatabaseException &&
            e.message == 'Impossível converter o dado do database'),
      );
    });

    test('delete author by Id', () async {
      when(() => localDatabase.delete(
            table: any(named: 'table'),
            idColumn: any(named: 'idColumn'),
            id: any(named: 'id'),
          )).thenThrow(const LocalDatabaseException('Error on database'));

      expect(
        () async => await authorsRepository.deleteAuthorById(
          id: 1,
        ),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
