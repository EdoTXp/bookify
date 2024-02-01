part of 'bookcase_detail_bloc.dart';

@immutable
sealed class BookcaseDetailEvent {}

final class GotBookcaseBooksEvent extends BookcaseDetailEvent {
  final int bookcaseId;

  GotBookcaseBooksEvent({required this.bookcaseId});
}

final class DeletedBookcaseEvent extends BookcaseDetailEvent {
  final int bookcaseId;

  DeletedBookcaseEvent({required this.bookcaseId});
}
