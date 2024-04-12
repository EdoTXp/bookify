part of 'separate_books_picker_bloc.dart';

sealed class SeparateBooksPickerState {}

final class SeparateBooksPickerLoadingState extends SeparateBooksPickerState {}

final class SeparateBooksPickerEmptyState extends SeparateBooksPickerState {}

final class SeparateBooksPickerLoadedState extends SeparateBooksPickerState {
  final List<BookModel> books;

  SeparateBooksPickerLoadedState({
    required this.books,
  });
}

final class SeparateBooksPickerErrorState extends SeparateBooksPickerState {
  final String errorMessage;

  SeparateBooksPickerErrorState({
    required this.errorMessage,
  });
}
