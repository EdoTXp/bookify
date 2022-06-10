part of 'book_bloc.dart';

@immutable
abstract class BookState {}

class BookLoadingState extends BookState {}

class BookEmptyState extends BookState {}

class BookLoadedState extends BookState {
  final List<BookModel> books;

  BookLoadedState({
    required this.books,
  });
}

class SingleBookLoadedState extends BookState {
  final BookModel book;

  SingleBookLoadedState({
    required this.book,
  });
}

class BookErrorSate extends BookState {
  final String message;

  BookErrorSate({
    required this.message,
  });
}
