part of 'book_on_bookcase_picker_bloc.dart';

sealed class BookOnBookcasePickerState {}

final class BookOnBookcasePickerLoadingState
    extends BookOnBookcasePickerState {}

final class BookOnBookcasePickerEmptyState extends BookOnBookcasePickerState {}

final class BookOnBookcasePickerLoadedState extends BookOnBookcasePickerState {
  final List<BookModel> books;

  BookOnBookcasePickerLoadedState({
    required this.books,
  });
}

final class BookOnBookcasePickerErrorState extends BookOnBookcasePickerState {
  final String errorMessage;

  BookOnBookcasePickerErrorState({
    required this.errorMessage,
  });
}
