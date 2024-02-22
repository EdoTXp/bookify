part of 'my_books_bloc.dart';

sealed class MyBooksState {}

final class MyBooksLoadingState extends MyBooksState {}

final class MyBooksEmptyState extends MyBooksState {}

final class MyBooksLoadedState extends MyBooksState {
  final List<BookModel> books;

  MyBooksLoadedState({required this.books});
}

final class MyBooksNotFoundState extends MyBooksState {}

final class MyBooksErrorState extends MyBooksState {
  final String errorMessage;

  MyBooksErrorState({required this.errorMessage});
}
