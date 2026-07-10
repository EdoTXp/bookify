import 'package:bookify/src/domain/dtos/reading_dto.dart';
import 'package:bookify/src/domain/models/book_model.dart';
import 'package:bookify/src/domain/models/bookcase_model.dart';
import 'package:bookify/src/domain/models/user_hour_time_model.dart';
import 'package:bookify/src/features/about/views/about_page.dart';
import 'package:bookify/src/features/auth/views/auth_page.dart';
import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/book_on_bookcase_detail/views/book_on_bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_books_insertion/views/bookcase_books_insertion_page.dart';
import 'package:bookify/src/features/bookcase_detail/views/bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/features/books_picker/views/books_picker_page.dart';
import 'package:bookify/src/features/contacts_picker/views/contacts_picker_page.dart';
import 'package:bookify/src/features/hour_time_calculator/views/hour_time_calculator_page.dart';
import 'package:bookify/src/features/loan_detail/views/loan_detail_page.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/features/notifications/views/notifications_page.dart';
import 'package:bookify/src/features/on_boarding/views/on_boarding_page.dart';
import 'package:bookify/src/features/programming_reading/views/programming_reading_page.dart';
import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/reading_page_time_calculator_page.dart';
import 'package:bookify/src/features/reading_page_timer/views/reading_page_timer_page.dart';
import 'package:bookify/src/features/readings_detail/views/readings_detail_page.dart';
import 'package:bookify/src/features/readings_insertion/views/readings_insertion_page.dart';
import 'package:bookify/src/features/readings_timer/views/readings_timer.page.dart';
import 'package:bookify/src/features/root/views/root_page.dart';
import 'package:bookify/src/features/settings/views/settings_page.dart';
import 'package:bookify/src/features/time_picker/views/time_picker_page.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  Routes._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final Map<String, WidgetBuilder> _staticRoutes = {
    OnBoardingPage.routeName: (context) => const OnBoardingPage(),
    AuthPage.routeName: (context) => const AuthPage(),
    ReadingPageTimeCalculatorPage.routeName: (context) =>
        const ReadingPageTimeCalculatorPage(),
    ReadingPageTimerPage.routeName: (context) => const ReadingPageTimerPage(),
    HourTimeCalculatorPage.routeName: (context) =>
        const HourTimeCalculatorPage(),
    ProgrammingReadingPage.routeName: (context) =>
        const ProgrammingReadingPage(),
    NotificationsPage.routeName: (context) => const NotificationsPage(),
    QrCodeScannerPage.routeName: (context) => const QrCodeScannerPage(),
    LoanInsertionPage.routeName: (context) => const LoanInsertionPage(),
    ContactsPickerPage.routeName: (context) => const ContactsPickerPage(),
    BooksPickerPage.routeName: (context) => const BooksPickerPage(),
    SettingsPage.routeName: (context) => const SettingsPage(),
    AboutPage.routeName: (context) => const AboutPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final builder = _staticRoutes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }

    switch (settings.name) {
      case RootPage.routeName:
        final isReadingNotification = settings.arguments is bool
            ? settings.arguments as bool
            : false;
        return MaterialPageRoute(
          builder: (_) =>
              RootPage(isReadingNotification: isReadingNotification),
          settings: settings,
        );

      case TimePickerPage.routeName:
        final args = settings.arguments as UserHourTimeModel?;
        return MaterialPageRoute(
          builder: (_) => TimePickerPage(userHourTimeModel: args),
          settings: settings,
        );

      case BookDetailPage.routeName:
        final args = settings.arguments as BookModel;
        return MaterialPageRoute(
          builder: (_) => BookDetailPage(bookModel: args),
          settings: settings,
        );

      case BookcaseDetailPage.routeName:
        final args = settings.arguments as BookcaseModel;
        return MaterialPageRoute(
          builder: (_) => BookcaseDetailPage(bookcaseModel: args),
          settings: settings,
        );

      case BookOnBookcaseDetailPage.routeName:
        final args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookOnBookcaseDetailPage(
            bookModel: args.first as BookModel,
            bookcaseId: args.last as int,
          ),
          settings: settings,
        );

      case BookcaseInsertionPage.routeName:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => args == null
              ? BookcaseInsertionPage.newBookcase()
              : BookcaseInsertionPage.updateBookcase(
                  bookcaseModel: args as BookcaseModel,
                ),
          settings: settings,
        );

      case BookcaseBooksInsertionPage.routeName:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BookcaseBooksInsertionPage(bookcaseId: args),
          settings: settings,
        );

      case LoanDetailPage.routeName:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LoanDetailPage(loanId: args),
          settings: settings,
        );

      case ReadingsInsertionPage.routeName:
        final args = settings.arguments as BookModel;
        return MaterialPageRoute(
          builder: (_) => ReadingsInsertionPage(book: args),
          settings: settings,
        );

      case ReadingsDetailPage.routeName:
        final args = settings.arguments as ReadingDto;
        return MaterialPageRoute(
          builder: (_) => ReadingsDetailPage(readingDto: args),
          settings: settings,
        );

      case ReadingsTimerPage.routeName:
        final args = settings.arguments as ReadingDto;
        return MaterialPageRoute(
          builder: (_) => ReadingsTimerPage(readingDto: args),
          settings: settings,
        );

      default:
        return null;
    }
  }

  static Widget getInitialHome(bool userIsLogged) {
    return userIsLogged ? const RootPage() : const OnBoardingPage();
  }
}
