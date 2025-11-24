import 'package:bookify/src/features/programming_reading/bloc/programming_reading_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final programmingReadingBlocProviders = [
  BlocProvider<ProgrammingReadingBloc>(
    create: (context) => ProgrammingReadingBloc(
      context.read(),
      context.read(),
    ),
  ),
];
