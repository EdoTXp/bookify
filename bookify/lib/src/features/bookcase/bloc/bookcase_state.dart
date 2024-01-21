part of 'bookcase_bloc.dart';

sealed class BookcaseState {}

final class BookcaseLoadingState extends BookcaseState {}

final class BookcaseLoadedState extends BookcaseState {
  final List<BookcaseDto> bookcasesDto;

  BookcaseLoadedState({required this.bookcasesDto});
}

final class BookcaseEmptyState extends BookcaseState {}

final class BookcaseErrorState extends BookcaseState {
  final String errorMessage;

  BookcaseErrorState({
    required this.errorMessage,
  });
}
