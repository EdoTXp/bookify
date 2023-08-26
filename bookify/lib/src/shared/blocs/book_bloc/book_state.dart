part of '../../../shared/blocs/book_bloc/book_bloc.dart';

sealed class BookState {}

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
