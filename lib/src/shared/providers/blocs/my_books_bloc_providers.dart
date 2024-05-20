import 'package:bookify/src/features/my_books/bloc/my_books_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final myBooksBlocProviders = [
  BlocProvider<MyBooksBloc>(
    create: (context) => MyBooksBloc(
      context.read(),
    ),
  ),
];
