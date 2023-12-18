import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDatabaseMock extends Mock implements LocalDatabase {}

void main() {
  final localDatabase = LocalDatabaseMock();
  final bookAuthorsRepository = BookAuthorsRepositoryImpl(localDatabase);

  group('Test normal CRUD book/authors without error ||', () {
    test('insert book/authors relationship', () async {
      when(() => localDatabase.insert(
            table: any(named: 'table'),
            values: any(named: 'values'),
          )).thenAnswer((_) async => 1);

      final bookAuthorsRelationship = await bookAuthorsRepository.insert(
        bookId: '1',
        authorId: 1,
      );

      expect(bookAuthorsRelationship, equals(1));
    });

    test('get book/authors relationship', () async {
      when(() =>
              localDatabase.getByColumn(
                  table: any(named: 'table'),
                  column: any(named: 'column'),
                  columnValues: any(named: 'columnValues')))
          .thenAnswer((_) async => [
                {'bookId': '1', 'authorId': 1},
              ]);

      final bookAuthorsRelationshipMap =
          await bookAuthorsRepository.getRelationshipsById(bookId: '1');

      expect(bookAuthorsRelationshipMap.last['bookId'], equals('1'));
      expect(bookAuthorsRelationshipMap.last['authorId'], equals(1));
    });

    test('delete book/authors relationship', () async {
      when(() => localDatabase.delete(
          table: any(named: 'table'),
          idColumn: any(named: 'idColumn'),
          id: any(named: 'id'))).thenAnswer((_) async => 1);

      final deletedRelationshipRow =
          await bookAuthorsRepository.delete(bookId: '1');

      expect(deletedRelationshipRow, equals(1));
    });
  });
}
