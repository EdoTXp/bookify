import 'package:bookify/src/core/models/loan_model.dart';

abstract interface class LoanService {
  Future<List<LoanModel>> getAll();
  Future<LoanModel> getById({required int loanId});
  Future<List<LoanModel>> getLoansByBookTitle({required String title});
  Future<int> countLoans();
  Future<int> insert({required LoanModel loanModel});
  Future<int> update({required LoanModel loanModel});
  Future<int> delete({required int loanId});
}
