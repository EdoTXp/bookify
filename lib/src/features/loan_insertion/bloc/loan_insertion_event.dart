part of 'loan_insertion_bloc.dart';

sealed class LoanInsertionEvent {}

final class InsertedLoanInsertionEvent extends LoanInsertionEvent {
  final String? observation;
  final DateTime loanDate;
  final DateTime devolutionDate;
  final String idContact;
  final String contactName;
  final String bookId;
  final String bookTitle;

  InsertedLoanInsertionEvent({
    this.observation,
    required this.loanDate,
    required this.devolutionDate,
    required this.contactName,
    required this.idContact,
    required this.bookId,
    required this.bookTitle,
  });
}
