import 'package:bookify/src/features/bookcase_insertion/bloc/bookcase_insertion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookcaseInsertionBlocProviders = [
  BlocProvider<BookcaseInsertionBloc>(
    create: (context) => BookcaseInsertionBloc(
      context.read(),
    ),
  ),
];
