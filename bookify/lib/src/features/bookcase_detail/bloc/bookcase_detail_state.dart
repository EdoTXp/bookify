part of 'bookcase_detail_bloc.dart';

@immutable
sealed class BookcaseDetailState {}

final class BookcaseDetailLoadingState extends BookcaseDetailState {}

final class BookcaseDetailBooksEmptyState extends BookcaseDetailState {}

final class BookcaseDetailBooksLoadedState extends BookcaseDetailState {
  final List<BookModel> books;

  BookcaseDetailBooksLoadedState({required this.books});
}

final class BookcaseDetailDeletedState extends BookcaseDetailState {}

final class BookcaseDetailErrorState extends BookcaseDetailState {
  final String errorMessage;

  BookcaseDetailErrorState({required this.errorMessage});
}
