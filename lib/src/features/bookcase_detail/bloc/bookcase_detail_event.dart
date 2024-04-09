part of 'bookcase_detail_bloc.dart';

@immutable
sealed class BookcaseDetailEvent {}

final class GotBookcaseBooksEvent extends BookcaseDetailEvent {
  final int bookcaseId;

  GotBookcaseBooksEvent({
    required this.bookcaseId,
  });
}

final class DeletedBookcaseEvent extends BookcaseDetailEvent {
  final int bookcaseId;

  DeletedBookcaseEvent({
    required this.bookcaseId,
  });
}

final class DeletedBooksOnBookcaseEvent extends BookcaseDetailEvent {
  final int bookcaseId;
  final List<BookModel> books;

  DeletedBooksOnBookcaseEvent({
    required this.bookcaseId,
    required this.books,
  });
}
