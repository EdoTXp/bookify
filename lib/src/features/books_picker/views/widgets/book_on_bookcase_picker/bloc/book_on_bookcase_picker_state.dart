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
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookOnBookcasePickerErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
