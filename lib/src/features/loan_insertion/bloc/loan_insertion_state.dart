part of 'loan_insertion_bloc.dart';

sealed class LoanInsertionState {}

final class LoanInsertionLoadingState extends LoanInsertionState {}

final class LoanInsertionInsertedState extends LoanInsertionState {}

final class LoanInsertionErrorState extends LoanInsertionState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  LoanInsertionErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
