import 'package:bookify/src/features/bookcase/views/bookcase/bloc/bookcase_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookcasePageProviders = [
  BlocProvider<BookcaseBloc>(
    create: (context) => BookcaseBloc(
      context.read(),
      context.read(),
    ),
  ),
];
