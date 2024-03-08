// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bookify/src/shared/constants/database_scripts/database_scripts.dart'
    as loan_table;
import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/repositories/loan_repository/loan_repository.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LocalDatabase _database;
  final _loanTableName = loan_table.loanTableName;

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
      throw LocalDatabaseException(
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
      throw LocalDatabaseException(
        'Impossível encontrar o empréstimo no database',
      );
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
      final rowUpdated = _database.update(
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
  Future<int> delete({required int loanModelId}) async {
    try {
      final deleteRow = await _database.delete(
        table: _loanTableName,
        idColumn: 'id',
        id: loanModelId,
      );

      return deleteRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
