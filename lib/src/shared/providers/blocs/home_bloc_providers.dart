import 'package:bookify/src/core/repositories/google_book_repository/google_books_repository.dart';
import 'package:bookify/src/core/repositories/google_book_repository/google_books_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../blocs/book_bloc/book_bloc.dart';
import '../../../core/rest_client/dio_rest_client_impl.dart';
import '../../../core/rest_client/rest_client.dart';

/// Providers for home Page which includes [DioRestClientImpl], [GoogleBooksRepositoryImpl] and [BookBloc]
final homeBlocProviders = [
  Provider<RestClient>(
    create: (_) => DioRestClientImpl(),
  ),
  RepositoryProvider<GoogleBooksRepository>(
    create: (context) => GoogleBooksRepositoryImpl(context.read()),
  ),
  BlocProvider<BookBloc>(
    create: (context) => BookBloc(context.read()),
  ),
];
