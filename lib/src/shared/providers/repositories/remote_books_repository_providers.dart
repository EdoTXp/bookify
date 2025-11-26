import 'package:bookify/src/core/repositories/remote_books_repository/remote_books_repository.dart';
import 'package:bookify/src/core/repositories/remote_books_repository/remote_books_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final remoteBooksRepositoryProviders = [
  RepositoryProvider<RemoteBooksRepository>(
    create: (context) => RemoteBooksRepositoryImpl(context.read()),
  ),
];
