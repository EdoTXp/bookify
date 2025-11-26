import 'package:bookify/src/core/data_sources/remote_books_data_source/google_books_data_source_impl.dart';
import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:provider/provider.dart';

final remoteBooksDataSourceProviders = [
  Provider<RemoteBooksDataSource>(
    create: (context) => GoogleBooksDataSourceImpl(context.read()),
  ),
];
