import 'package:bookify/src/features/bookcase_detail/bloc/bookcase_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookcaseDetailBlocProviders = [
  BlocProvider<BookcaseDetailBloc>(
    create: (context) => BookcaseDetailBloc(
      context.read(),
      context.read(),
    ),
  ),
];
