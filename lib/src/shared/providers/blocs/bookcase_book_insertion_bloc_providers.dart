import 'package:bookify/src/features/bookcase_books_insertion/bloc/bookcase_books_insertion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookcaseBooksInsertionBlocProviders = [
  BlocProvider<BookcaseBooksInsertionBloc>(
    create: (context) => BookcaseBooksInsertionBloc(
      context.read(),
      context.read(),
    ),
  ),
];
