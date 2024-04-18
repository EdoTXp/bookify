part of 'loan_detail_bloc.dart';

sealed class LoanDetailEvent {}

final class GotLoanDetailEvent extends LoanDetailEvent {
  final int id;

  GotLoanDetailEvent({
    required this.id,
  });
}

final class DeletedLoanDetailEvent extends LoanDetailEvent {
  final int loanId;
  final String bookId;

  DeletedLoanDetailEvent({
    required this.loanId,
    required this.bookId,
  });
}
