part of 'reading_page_time_calculator_bloc.dart';

sealed class ReadingPageTimeCalculatorState {}

final class ReadingPageTimeCalculatorLoadingState
    extends ReadingPageTimeCalculatorState {}

final class ReadingPageTimeCalculatorInsertedState
    extends ReadingPageTimeCalculatorState {}

final class ReadingPageTimeCalculatorErrorState
    extends ReadingPageTimeCalculatorState {
  final String errorMessage;

  ReadingPageTimeCalculatorErrorState({
    required this.errorMessage,
  });
}
