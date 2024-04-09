part of 'bookcase_books_insertion_bloc.dart';

sealed class BookcaseBooksInsertionState {}

final class BookcaseBooksInsertionLoadingState
    extends BookcaseBooksInsertionState {}

final class BookcaseBooksInsertionEmptyState
    extends BookcaseBooksInsertionState {
  final String message;

  BookcaseBooksInsertionEmptyState({
    required this.message,
  });
}

final class BookcaseBooksInsertionLoadedState
    extends BookcaseBooksInsertionState {
  final List<BookModel> books;

  BookcaseBooksInsertionLoadedState({
    required this.books,
  });
}

final class BookcaseBooksInsertionInsertedState
    extends BookcaseBooksInsertionState {}

final class BookcaseBooksInsertionErrorState
    extends BookcaseBooksInsertionState {
  final String errorMessage;

  BookcaseBooksInsertionErrorState({
    required this.errorMessage,
  });
}
