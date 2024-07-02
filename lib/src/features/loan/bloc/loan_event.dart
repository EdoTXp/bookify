part of 'loan_bloc.dart';

sealed class LoanEvent {}

final class GotAllLoansEvent extends LoanEvent {}

final class FoundLoanByBookTitleEvent extends LoanEvent {
  final String searchQueryName;

  FoundLoanByBookTitleEvent({
    required this.searchQueryName,
  });
}
