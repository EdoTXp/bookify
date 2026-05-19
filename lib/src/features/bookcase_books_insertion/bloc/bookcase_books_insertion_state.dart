part of 'bookcase_books_insertion_bloc.dart';

enum BookcaseBooksEmptyReason {
  noBooksRegistered,
  allBooksAlreadyInserted,
}

sealed class BookcaseBooksInsertionState {}

final class BookcaseBooksInsertionLoadingState
    extends BookcaseBooksInsertionState {}

final class BookcaseBooksInsertionEmptyState
    extends BookcaseBooksInsertionState {
  final BookcaseBooksEmptyReason reason;

  BookcaseBooksInsertionEmptyState({
    required this.reason,
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
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookcaseBooksInsertionErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
