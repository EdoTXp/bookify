part of 'loan_insertion_bloc.dart';

sealed class LoanInsertionEvent {}

final class InsertedLoanInsertionEvent extends LoanInsertionEvent {
  final String? observation;
  final DateTime loanDate;
  final DateTime devolutionDate;
  final String idContact;
  final String bookId;
  final String notificationTitle;
  final String notificationBody;

  InsertedLoanInsertionEvent({
    this.observation,
    required this.loanDate,
    required this.devolutionDate,
    required this.idContact,
    required this.bookId,
    required this.notificationTitle,
    required this.notificationBody,
  });
}
