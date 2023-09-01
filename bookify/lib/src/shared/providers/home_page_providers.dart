import 'package:bookify/src/shared/repositories/book_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/book_repository/google_books_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/book_bloc/book_bloc.dart';
import '../rest_client/dio_rest_client_impl.dart';
import '../rest_client/rest_client.dart';

final homePageProviders = [
  Provider<RestClient>(create: ((_) => DioRestClientImpl())),
  RepositoryProvider<BooksRepository>(
      create: ((context) => GoogleBookRepositoryImpl(context.read()))),
  BlocProvider<BookBloc>(create: ((context) => BookBloc(context.read())))
];
