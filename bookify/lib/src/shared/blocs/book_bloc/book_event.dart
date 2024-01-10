part of '../../../shared/blocs/book_bloc/book_bloc.dart';

sealed class BookEvent {}

final class GotAllBooksEvent extends BookEvent {}

final class FoundBooksByIsbnEvent extends BookEvent {
  final String isbn;

  FoundBooksByIsbnEvent({
    required this.isbn,
  });
}

final class FoundBooksByAuthorEvent extends BookEvent {
  final String author;

  FoundBooksByAuthorEvent({
    required this.author,
  });
}

final class FoundBooksByCategoryEvent extends BookEvent {
  final String category;

  FoundBooksByCategoryEvent({
    required this.category,
  });
}

final class FoundBooksByPublisherEvent extends BookEvent {
  final String publisher;

  FoundBooksByPublisherEvent({
    required this.publisher,
  });
}

final class FoundBooksByTitleEvent extends BookEvent {
  final String title;

  FoundBooksByTitleEvent({
    required this.title,
  });
}
