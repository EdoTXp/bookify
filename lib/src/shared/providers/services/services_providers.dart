import 'package:bookify/src/domain/services/app_version_service/app_version_service.dart';
import 'package:bookify/src/domain/services/app_version_service/app_version_service_impl.dart';
import 'package:bookify/src/domain/services/book_service/book_service.dart';
import 'package:bookify/src/domain/services/book_service/book_service_impl.dart';
import 'package:bookify/src/domain/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/domain/services/bookcase_service/bookcase_service_impl.dart';
import 'package:bookify/src/domain/services/contacts_service/contacts_service.dart';
import 'package:bookify/src/domain/services/contacts_service/contacts_service_impl.dart';
import 'package:bookify/src/domain/services/loan_services/loan_service.dart';
import 'package:bookify/src/domain/services/loan_services/loan_service_impl.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service.dart';
import 'package:bookify/src/domain/services/notifications_service/notifications_service_impl.dart';
import 'package:bookify/src/domain/services/reading_services/reading_service.dart';
import 'package:bookify/src/domain/services/reading_services/reading_service_impl.dart';
import 'package:provider/provider.dart';

/// Provider that includes all services.
final servicesProviders = [
  Provider<NotificationsService>(
    create: (_) => NotificationsServiceImpl(),
  ),
  Provider<ContactsService>(
    create: (context) => ContactsServiceImpl(),
  ),
  Provider<AppVersionService>(
    create: (context) => const AppVersionServiceImpl(),
  ),
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
