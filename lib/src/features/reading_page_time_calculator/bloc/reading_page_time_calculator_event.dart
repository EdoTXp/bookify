part of 'reading_page_time_calculator_bloc.dart';

sealed class ReadingPageTimeCalculatorEvent {}

final class InsertedReadingPageTimeEvent
    extends ReadingPageTimeCalculatorEvent {
  final int readingPageTime;

  InsertedReadingPageTimeEvent({
    required this.readingPageTime,
  });
}
