part of '../../../shared/blocs/book_bloc/book_bloc.dart';

sealed class BookEvent {}

class GotAllBooksEvent extends BookEvent {}

class FoundBooksByIsbnEvent extends BookEvent {
  final String isbn;

  FoundBooksByIsbnEvent({
    required this.isbn,
  });
}

class FoundBooksByAuthorEvent extends BookEvent {
  final String author;

  FoundBooksByAuthorEvent({
    required this.author,
  });
}

class FoundBooksByCategoryEvent extends BookEvent {
  final String category;

  FoundBooksByCategoryEvent({
    required this.category,
  });
}

class FoundBooksByPublisherEvent extends BookEvent {
  final String publisher;

  FoundBooksByPublisherEvent({
    required this.publisher,
  });
}

class FoundBooksByTitleEvent extends BookEvent {
  final String title;

  FoundBooksByTitleEvent({
    required this.title,
  });
}
