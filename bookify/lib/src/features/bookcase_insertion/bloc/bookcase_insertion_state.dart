part of 'bookcase_insertion_bloc.dart';

@immutable
sealed class BookcaseInsertionState {}

final class BookcaseInsertionLoadingState extends BookcaseInsertionState {}

final class BookcaseInsertionInsertedState extends BookcaseInsertionState {
  final String bookcaseInsertionMessage;

  BookcaseInsertionInsertedState({required this.bookcaseInsertionMessage});
}

final class BookcaseInsertionErrorState extends BookcaseInsertionState {
  final String errorMessage;

  BookcaseInsertionErrorState({
    required this.errorMessage,
  });
}
