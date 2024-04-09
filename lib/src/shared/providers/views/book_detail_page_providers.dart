import 'package:bookify/src/features/book_detail/bloc/book_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Providers which includes all the necessary classes for BookDetail [BookDetailBloc].
final bookDetailPageProviders = [
  BlocProvider<BookDetailBloc>(
    create: (context) => BookDetailBloc(
      context.read(),
    ),
  ),
];
