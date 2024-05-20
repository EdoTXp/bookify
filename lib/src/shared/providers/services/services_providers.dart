import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/book_service/book_service_impl.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service_impl.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service_impl.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service_impl.dart';
import 'package:provider/provider.dart';

/// Provider that includes all services.
final servicesProviders = [
  Provider<BookService>(
    create: (context) => BookServiceImpl(
      booksRepository: context.read(),
      authorsRepository: context.read(),
      categoriesRepository: context.read(),
      bookAuthorsRepository: context.read(),
      bookCategoriesRepository: context.read(),
    ),
  ),
  Provider<BookcaseService>(
    create: (context) => BookcaseServiceImpl(
      bookcaseRepository: context.read(),
      bookOnCaseRepository: context.read(),
    ),
  ),
  Provider<LoanService>(
    create: (context) => LoanServiceImpl(
      context.read(),
    ),
  ),
  Provider<ReadingService>(
    create: (context) => ReadingServiceImpl(
      context.read(),
    ),
  ),
];
