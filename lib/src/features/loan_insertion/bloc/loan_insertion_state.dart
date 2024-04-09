part of 'loan_insertion_bloc.dart';

sealed class LoanInsertionState {}

final class LoanInsertionLoadingState extends LoanInsertionState {}

final class LoanInsertionInsertedState extends LoanInsertionState {
  final String loanInsertionMessage;

  LoanInsertionInsertedState({
    required this.loanInsertionMessage,
  });
}

final class LoanInsertionErrorState extends LoanInsertionState {
  final String errorMessage;

  LoanInsertionErrorState({
    required this.errorMessage,
  });
}
