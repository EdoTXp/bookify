part of 'loan_insertion_bloc.dart';

sealed class LoanInsertionState {}

final class LoanInsertionLoadingState extends LoanInsertionState {}

final class LoanInsertionInsertedState extends LoanInsertionState {
  final int loanId;
  final String loanInsertionMessage;
  final DateTime devolutionDate;

  LoanInsertionInsertedState({
    required this.loanId,
    required this.loanInsertionMessage,
    required this.devolutionDate,
  });
}

final class LoanInsertionErrorState extends LoanInsertionState {
  final String errorMessage;

  LoanInsertionErrorState({
    required this.errorMessage,
  });
}
