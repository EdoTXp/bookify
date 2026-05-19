part of 'book_detail_bloc.dart';

sealed class BookDetailState {}

final class BookDetailLoadingState extends BookDetailState {}

final class BookDetailLoadedState extends BookDetailState {
  final bool bookIsInserted;

  BookDetailLoadedState({
    required this.bookIsInserted,
  });
}

final class BookDetailErrorState extends BookDetailState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookDetailErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
