part of 'book_on_bookcase_detail_bloc.dart';

sealed class BookOnBookcaseDetailState {}

final class BookOnBookcaseDetailLoadingState
    extends BookOnBookcaseDetailState {}

final class BookOnBookcaseDetailLoadedState extends BookOnBookcaseDetailState {
  final int bookcasesCount;

  BookOnBookcaseDetailLoadedState({
    required this.bookcasesCount,
  });
}

final class BookOnBookcaseDetailDeletedState
    extends BookOnBookcaseDetailState {}

final class BookOnBookcaseDetailErrorState extends BookOnBookcaseDetailState {
  final String errorMessage;

  BookOnBookcaseDetailErrorState({
    required this.errorMessage,
  });
}
