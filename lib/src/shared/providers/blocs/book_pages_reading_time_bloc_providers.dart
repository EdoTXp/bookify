import 'package:bookify/src/features/book_detail/widgets/book_pages_reading_time/bloc/book_pages_reading_time_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookPagesReadingTimeBlocProviders = [
  BlocProvider<BookPagesReadingTimeBloc>(
    create: (context) => BookPagesReadingTimeBloc(
      context.read(),
    ),
  ),
];
