import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart';
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/repositories/loan_repository/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LocalDatabase _database;
  final _loanTableName = DatabaseScripts().loanTableName;
  final _bookTableName = DatabaseScripts().bookTableName;

  LoanRepositoryImpl(this._database);

  @override
  Future<List<LoanModel>> getAll() async {
    try {
      final loanMap = await _database.getAll(
        table: _loanTableName,
        orderColumn: 'devolutionDate',
        orderBy: OrderByType.ascendant,
      );
      final loans = loanMap.map(LoanModel.fromMap).toList();

      return loans;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar os empréstimos no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<LoanModel>> getLoansByBookTitle({required String title}) async {
    try {
      final loanMap = await _database.getByJoin(
        columns: ['$_loanTableName.*'],
        table: _loanTableName,
        innerJoinTable: _bookTableName,
        onColumn: '$_loanTableName.bookId',
        onArgs: '$_bookTableName.id',
        whereColumn: 'title',
        whereArgs: title,
        usingLikeCondition: true,
      );
      final loans = loanMap.map(LoanModel.fromMap).toList();

      return loans;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar os empréstimos no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<LoanModel> getById({required int loanId}) async {
    try {
      final loanMap = await _database.getItemById(
        table: _loanTableName,
        idColumn: 'id',
        id: loanId,
      );
      final loan = LoanModel.fromMap(loanMap);

      return loan;
    } on TypeError {
      throw const LocalDatabaseException(
        'Impossível encontrar o empréstimo no database',
      );
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countLoans() async {
    try {
      final loansCount = await _database.countItems(
        table: _loanTableName,
      );

      return loansCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insert({required LoanModel loanModel}) async {
    try {
      final loanId = await _database.insert(
        table: _loanTableName,
        values: loanModel.toMap(),
      );

      return loanId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> update({required LoanModel loanModel}) async {
    try {
      final rowUpdated = await _database.update(
        table: _loanTableName,
        values: loanModel.toMap(),
        idColumn: 'id',
        id: loanModel.id,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> delete({required int loanId}) async {
    try {
      final deleteRow = await _database.delete(
        table: _loanTableName,
        idColumn: 'id',
        id: loanId,
      );

      return deleteRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
