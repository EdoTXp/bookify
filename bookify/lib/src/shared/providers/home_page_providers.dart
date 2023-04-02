import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/book_bloc/book_bloc.dart';
import '../http_client/dio_http_client.dart';
import '../repositories/google_books_repository.dart';
import '../interfaces/books_repository_interface.dart';
import '../interfaces/http_client_interface.dart';

final homePageProviders = [
  Provider<IHttpClient>(create: ((_) => DioHttpClient())),
  Provider<IBooksRepository>(
      create: ((context) => GoogleBookRepository(context.read()))),
  BlocProvider<BookBloc>(create: ((context) => BookBloc(context.read())))
];
