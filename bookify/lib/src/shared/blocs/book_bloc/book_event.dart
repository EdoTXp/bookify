part of '../../../shared/blocs/book_bloc/book_bloc.dart';

sealed class BookEvent {}

class GotAllBooksEvent extends BookEvent {}

class FindedBookByIsbnEvent extends BookEvent {
  final int isbn;

  FindedBookByIsbnEvent({
    required this.isbn,
  });
}

class FindedBooksByAuthorEvent extends BookEvent {
  final String author;

  FindedBooksByAuthorEvent({
    required this.author,
  });
}

class FindedBooksByCategoryEvent extends BookEvent {
  final String category;

  FindedBooksByCategoryEvent({
    required this.category,
  });
}

class FindedBooksByPublisherEvent extends BookEvent {
  final String publisher;

  FindedBooksByPublisherEvent({
    required this.publisher,
  });
}

class FindedBooksByTitleEvent extends BookEvent {
  final String title;

  FindedBooksByTitleEvent({
    required this.title,
  });
}
