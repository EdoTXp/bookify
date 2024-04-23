import 'package:bookify/src/shared/models/loan_model.dart';

abstract interface class LoanRepository {
  Future<List<LoanModel>> getAll();
  Future<List<LoanModel>> getLoansByBookTitle({required String title});
  Future<LoanModel> getById({required int loanId});
  Future<int> insert({required LoanModel loanModel});
  Future<int> update({required LoanModel loanModel});
  Future<int> delete({required int loanId});
}
