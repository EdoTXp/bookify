part of 'book_bloc.dart';

@immutable
abstract class BookState {}

class BooksLoadingState extends BookState {}

class BookEmptyState extends BookState {}

class BooksLoadedState extends BookState {
  final List<BookModel> books;

  BooksLoadedState({
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
