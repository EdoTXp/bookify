import 'package:bookify/src/features/reading_page_time_calculator/bloc/reading_page_time_calculator_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingPageTimeCalculatorBlocProviders = [
  BlocProvider<ReadingPageTimeCalculatorBloc>(
    create: (context) => ReadingPageTimeCalculatorBloc(
      context.read(),
    ),
  ),
];
