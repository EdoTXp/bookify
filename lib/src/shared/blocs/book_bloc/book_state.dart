part of 'book_bloc.dart';

sealed class BookState {}

final class BooksLoadingState extends BookState {}

final class BookEmptyState extends BookState {}

final class BooksLoadedState extends BookState {
  final List<BookModel> books;

  BooksLoadedState({
    required this.books,
  });
}

final class BookErrorSate extends BookState {
  final String errorMessage;

  BookErrorSate({
    required this.errorMessage,
  });
}
