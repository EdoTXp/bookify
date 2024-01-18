import 'package:bookify/src/shared/database/local_database.dart';
import 'package:bookify/src/shared/database/local_database_impl.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository_impl.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository_impl.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository_impl.dart';
import 'package:bookify/src/shared/repositories/book_on_case_repository/book_on_case_repository.dart';
import 'package:bookify/src/shared/repositories/book_on_case_repository/book_on_case_repository_impl.dart';
import 'package:bookify/src/shared/repositories/bookcase_repository/bookcase_repository.dart';
import 'package:bookify/src/shared/repositories/bookcase_repository/bookcase_repository_impl.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository_impl.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

///Providers which includes the local database [LocalDatabase] and all its repositories.
final repositoriesProviders = [
  Provider<LocalDatabase>(
    create: (_) => LocalDatabaseImpl(),
  ),
  RepositoryProvider<BooksRepository>(
    create: (context) => BooksRepositoryImpl(context.read()),
  ),
  RepositoryProvider<AuthorsRepository>(
    create: (context) => AuthorsRepositoryImpl(context.read()),
  ),
  RepositoryProvider<CategoriesRepository>(
    create: (context) => CategoriesRepositoryImpl(context.read()),
  ),
  RepositoryProvider<BookAuthorsRepository>(
    create: (context) => BookAuthorsRepositoryImpl(context.read()),
  ),
  RepositoryProvider<BookCategoriesRepository>(
    create: (context) => BookCategoriesRepositoryImpl(context.read()),
  ),
  RepositoryProvider<BookcaseRepository>(
    create: (context) => BookcaseRepositoryImpl(context.read()),
  ),
  RepositoryProvider<BookOnCaseRepository>(
    create: (context) => BookOnCaseRepositoryImpl(context.read()),
  ),
];
