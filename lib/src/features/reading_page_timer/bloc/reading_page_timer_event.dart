part of 'reading_page_timer_bloc.dart';

sealed class ReadingPageTimerEvent {}

final class InsertedReadingPageTimeEvent extends ReadingPageTimerEvent {
  final int readingPageTime;

  InsertedReadingPageTimeEvent({
    required this.readingPageTime,
  });
}
