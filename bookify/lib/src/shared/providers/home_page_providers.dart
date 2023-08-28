import 'package:bookify/src/shared/repositories/book_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/book_repository/google_books_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/book_bloc/book_bloc.dart';
import '../http_client/dio_http_client_impl.dart';
import '../http_client/dio_http_client.dart';

final homePageProviders = [
  Provider<DioHttpClient>(create: ((_) => DioHttpClientImpl())),
  RepositoryProvider<BooksRepository>(
      create: ((context) => GoogleBookRepositoryImpl(context.read()))),
  BlocProvider<BookBloc>(create: ((context) => BookBloc(context.read())))
];
