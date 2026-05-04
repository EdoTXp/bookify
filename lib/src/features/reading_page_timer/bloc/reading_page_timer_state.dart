part of 'reading_page_timer_bloc.dart';

sealed class ReadingPageTimerState {}

final class ReadingPageTimerLoadingState extends ReadingPageTimerState {}

final class ReadingPageTimerInsertedState extends ReadingPageTimerState {}

final class ReadingPageTimerErrorState extends ReadingPageTimerState {
  final StorageErrorCode errorCode;
  final String? errorDescriptionMessage;

  ReadingPageTimerErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
