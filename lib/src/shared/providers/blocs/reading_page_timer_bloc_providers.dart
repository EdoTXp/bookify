import 'package:bookify/src/features/reading_page_timer/bloc/reading_page_timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final readingPageTimerBlocProviders = [
  BlocProvider<ReadingPageTimerBloc>(
    create: (context) => ReadingPageTimerBloc(
      context.read(),
    ),
  ),
];
