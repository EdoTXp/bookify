part of 'loan_bloc.dart';

sealed class LoanEvent {}

final class GotAllLoansEvent extends LoanEvent {}

final class FindedLoanByBookNameEvent extends LoanEvent {
  final String searchQueryName;

  FindedLoanByBookNameEvent({
    required this.searchQueryName,
  });
}
