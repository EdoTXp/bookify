import 'package:bookify/src/shared/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/book_service/book_service_impl.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service_impl.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service_impl.dart';
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
  Provider<ContactsService>(
    create: (context) => ContactsService(),
  ),
];
