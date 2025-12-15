import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';

final homeBlocProviders = [
  BlocProvider<BookBloc>(
    create: (context) => BookBloc(context.read()),
  ),
];
