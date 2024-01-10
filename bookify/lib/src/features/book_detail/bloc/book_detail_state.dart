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
  final String errorMessage;

  BookDetailErrorState({
    required this.errorMessage,
  });
}
