part of 'loan_bloc.dart';

sealed class LoanEvent {}

final class GotAllLoansEvent extends LoanEvent {}

final class FindedLoanByBookTitleEvent extends LoanEvent {
  final String searchQueryName;

  FindedLoanByBookTitleEvent({
    required this.searchQueryName,
  });
}
