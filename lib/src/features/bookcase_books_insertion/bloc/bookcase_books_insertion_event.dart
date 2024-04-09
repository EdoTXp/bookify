part of 'bookcase_books_insertion_bloc.dart';

sealed class BookcaseBooksInsertionEvent {}

final class GotAllBooksForThisBookcaseEvent
    extends BookcaseBooksInsertionEvent {
  final int bookcaseId;

  GotAllBooksForThisBookcaseEvent({required this.bookcaseId});
}

final class InsertBooksOnBookcaseEvent extends BookcaseBooksInsertionEvent {
  final int bookcaseId;
  final List<BookModel> books;

  InsertBooksOnBookcaseEvent({required this.bookcaseId, required this.books});
}
