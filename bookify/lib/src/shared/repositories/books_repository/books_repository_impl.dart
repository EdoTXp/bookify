import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as book_table;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository.dart';

class BooksRepositoryImpl implements BooksRepository {
  final LocalDatabase _database;
  final _bookTableName = book_table.bookTableName;

  BooksRepositoryImpl(this._database);

  @override
  Future<List<BookModel>> getAll() async {
    final booksMap = await _database.getAll(table: _bookTableName);
    final booksModel = booksMap.map(BookModel.fromMap).toList();
    return booksModel;
  }

  @override
  Future<BookModel> getBookById({required String id}) async {
    final bookMap = await _database.getById(
      table: _bookTableName,
      idColumn: 'id',
      id: id,
    );

    final bookModel = BookModel.fromMap(bookMap);
    return bookModel;
  }

  @override
  Future<int> insert({required BookModel bookModel}) async {
    final rowInserted = await _database.insert(
      table: _bookTableName,
      values: bookModel.toMap(),
    );
    return rowInserted;
  }

  @override
  Future<bool> verifyBookIsAlreadyInserted({required String id}) async {
    final isBookInserted = await _database.verifyItemIsAlreadyInserted(
      table: _bookTableName,
      column: 'id',
      columnValue: id,
    );
    return isBookInserted;
  }

  @override
  Future<int> deleteBookById({required String id}) async {
    final rowDeleted = await _database.delete(
      table: _bookTableName,
      idColumn: 'id',
      id: id,
    );
    return rowDeleted;
  }
}
