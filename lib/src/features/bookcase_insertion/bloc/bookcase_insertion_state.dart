part of 'bookcase_insertion_bloc.dart';

enum BookcaseInsertionSuccessReason {
  inserted,
  updated,
}

@immutable
sealed class BookcaseInsertionState {}

final class BookcaseInsertionLoadingState extends BookcaseInsertionState {}

final class BookcaseInsertionInsertedState extends BookcaseInsertionState {
  final BookcaseInsertionSuccessReason reason;

  BookcaseInsertionInsertedState({required this.reason});
}

final class BookcaseInsertionErrorState extends BookcaseInsertionState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookcaseInsertionErrorState({
    required this.errorCode,
    required this.errorDescriptionMessage,
  });
}
