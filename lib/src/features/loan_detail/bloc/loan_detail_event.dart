part of 'loan_detail_bloc.dart';

sealed class LoanDetailEvent {}

final class GotLoanDetailEvent extends LoanDetailEvent {
  final int id;

  GotLoanDetailEvent({
    required this.id,
  });
}

final class FinishedLoanDetailEvent extends LoanDetailEvent {
  final int loanId;
  final String bookId;

  FinishedLoanDetailEvent({
    required this.loanId,
    required this.bookId,
  });
}
