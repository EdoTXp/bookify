import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookcaseBlocProviders = [
  BlocProvider<BookcaseBloc>(
    create: (context) => BookcaseBloc(
      context.read(),
      context.read(),
    ),
  ),
];
