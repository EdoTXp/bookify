part of 'bookcase_detail_bloc.dart';

@immutable
sealed class BookcaseDetailState {}

final class BookcaseDetailLoadingState extends BookcaseDetailState {}

final class BookcaseDetailEmptyState extends BookcaseDetailState {}

final class BookcaseDetailLoadedState extends BookcaseDetailState {
  final List<BookModel> books;

  BookcaseDetailLoadedState({required this.books});
}

final class BookcaseDetailErrorState extends BookcaseDetailState {
  final String errorMessage;

  BookcaseDetailErrorState({required this.errorMessage});
}
