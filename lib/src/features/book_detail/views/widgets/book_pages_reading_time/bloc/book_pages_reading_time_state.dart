part of 'book_pages_reading_time_bloc.dart';

sealed class BookPagesReadingTimeState {}

final class BookPagesReadingTimeLoadingState
    extends BookPagesReadingTimeState {}

final class BookPagesReadingTimeLoadedState extends BookPagesReadingTimeState {
  final UserPageReadingTimeModel userPageReadingTime;

  BookPagesReadingTimeLoadedState({
    required this.userPageReadingTime,
  });
}

final class BookPagesReadingTimeErrorState extends BookPagesReadingTimeState {
  final StorageErrorCode errorCode;
  final String? errorDescriptionMessage;

  BookPagesReadingTimeErrorState({
     required this.errorCode,
    this.errorDescriptionMessage,
  });
}
