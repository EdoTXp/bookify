part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class GetAllBooksEvent extends BookEvent {}

class FindBookByIsbnEvent extends BookEvent {
  final int isbn;

  FindBookByIsbnEvent({
    required this.isbn,
  });
}

class FindBooksByAuthorEvent extends BookEvent {
  final String author;

  FindBooksByAuthorEvent({
    required this.author,
  });
}

class FindBooksByCategoryEvent extends BookEvent {
  final String category;

  FindBooksByCategoryEvent({
    required this.category,
  });
}

class FindBooksByPublisherEvent extends BookEvent {
  final String publisher;

  FindBooksByPublisherEvent({
    required this.publisher,
  });
}

class FindBooksByTitleEvent extends BookEvent {
  final String title;

  FindBooksByTitleEvent({
    required this.title,
  });
}
