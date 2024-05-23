part of 'book_pages_reading_time_bloc.dart';

sealed class BookPagesReadingTimeState {}

final class BookPagesReadingTimeLoadingState
    extends BookPagesReadingTimeState {}

final class BookPagesReadingTimeLoadedState extends BookPagesReadingTimeState {
  final UserPageReadingTime userPageReadingTime;

  BookPagesReadingTimeLoadedState({
    required this.userPageReadingTime,
  });
}

final class BookPagesReadingTimeErrorState extends BookPagesReadingTimeState {
  final String errorMessage;

  BookPagesReadingTimeErrorState({
    required this.errorMessage,
  });
}
