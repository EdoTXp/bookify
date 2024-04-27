import 'package:bookify/src/features/book_on_bookcase_detail/bloc/book_on_bookcase_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final bookOnBookcaseDetailPageProviders = [
  BlocProvider<BookOnBookcaseDetailBloc>(
    create: (context) => BookOnBookcaseDetailBloc(
      context.read(),
    ),
  ),
];
