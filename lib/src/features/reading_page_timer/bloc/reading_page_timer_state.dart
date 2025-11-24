part of 'reading_page_timer_bloc.dart';

sealed class ReadingPageTimerState {}

final class ReadingPageTimerLoadingState extends ReadingPageTimerState {}

final class ReadingPageTimerInsertedState extends ReadingPageTimerState {}

final class ReadingPageTimerErrorState extends ReadingPageTimerState {
  final String errorMessage;

  ReadingPageTimerErrorState({
    required this.errorMessage,
  });
}
