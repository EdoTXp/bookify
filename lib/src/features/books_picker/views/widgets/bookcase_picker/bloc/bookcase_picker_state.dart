part of 'bookcase_picker_bloc.dart';

sealed class BookcasePickerState {}

final class BookcasePickerLoadingState extends BookcasePickerState {}

final class BookcasePickerEmptyState extends BookcasePickerState {}

final class BookcasePickerLoadedState extends BookcasePickerState {
  final List<BookcaseDto> bookcasesDto;

  BookcasePickerLoadedState({required this.bookcasesDto});
}

final class BookcasePickerErrorState extends BookcasePickerState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookcasePickerErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
