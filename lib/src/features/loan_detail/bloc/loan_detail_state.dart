part of 'loan_detail_bloc.dart';

sealed class LoanDetailState {}

final class LoanDetailLoadingState extends LoanDetailState {}

final class LoanDetailLoadedState extends LoanDetailState {
  final LoanDto loanDto;

  LoanDetailLoadedState({
    required this.loanDto,
  });
}

final class LoanDetailFinishedState extends LoanDetailState {}

final class LoanDetailErrorState extends LoanDetailState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  LoanDetailErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
