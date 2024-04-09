part of 'my_books_bloc.dart';

sealed class MyBooksEvent {}

final class GotAllBooksEvent extends MyBooksEvent {}

final class SearchedBooksEvent extends MyBooksEvent{
  final String searchQuery;

  SearchedBooksEvent({required this.searchQuery});
}
