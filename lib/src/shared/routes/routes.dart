import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/models/user_hour_time_model.dart';
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
import 'package:flutter/widgets.dart';

abstract class Routes {
  Routes._();

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static Map<String, WidgetBuilder> routes = {
    OnBoardingPage.routeName: (context) => const OnBoardingPage(),
    AuthPage.routeName: (context) => const AuthPage(),
    ReadingPageTimeCalculatorPage.routeName: (context) =>
        const ReadingPageTimeCalculatorPage(),
    ReadingPageTimerPage.routeName: (context) => const ReadingPageTimerPage(),
    HourTimeCalculatorPage.routeName: (context) =>
        const HourTimeCalculatorPage(),
    ProgrammingReadingPage.routeName: (context) =>
        const ProgrammingReadingPage(),
    TimePickerPage.routeName: (context) => TimePickerPage(
          userHourTimeModel:
              ModalRoute.of(context)!.settings.arguments as UserHourTimeModel?,
        ),
    NotificationsPage.routeName: (context) => const NotificationsPage(),
    RootPage.routeName: (context) => const RootPage(),
    BookDetailPage.routeName: (context) => BookDetailPage(
          bookModel: ModalRoute.of(context)!.settings.arguments as BookModel,
        ),
    QrCodeScannerPage.routeName: (context) => const QrCodeScannerPage(),
    BookcaseDetailPage.routeName: (context) => BookcaseDetailPage(
          bookcaseModel:
              ModalRoute.of(context)!.settings.arguments as BookcaseModel,
        ),
    BookOnBookcaseDetailPage.routeName: (context) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as List<dynamic>;

      return BookOnBookcaseDetailPage(
        bookModel: arguments.first as BookModel,
        bookcaseId: arguments.last as int,
      );
    },
    BookcaseInsertionPage.routeName: (context) => BookcaseInsertionPage(
          bookcaseModel:
              ModalRoute.of(context)!.settings.arguments as BookcaseModel?,
        ),
    BookcaseBooksInsertionPage.routeName: (context) =>
        BookcaseBooksInsertionPage(
          bookcaseId: ModalRoute.of(context)!.settings.arguments as int,
        ),
    LoanInsertionPage.routeName: (context) => const LoanInsertionPage(),
    LoanDetailPage.routeName: (context) => LoanDetailPage(
          loanId: ModalRoute.of(context)!.settings.arguments as int,
        ),
    ReadingsInsertionPage.routeName: (context) => ReadingsInsertionPage(
          book: ModalRoute.of(context)!.settings.arguments as BookModel,
        ),
    ReadingsDetailPage.routeName: (context) => ReadingsDetailPage(
          readingDto: ModalRoute.of(context)!.settings.arguments as ReadingDto,
        ),
    ReadingsTimerPage.routeName: (context) => ReadingsTimerPage(
          readingDto: ModalRoute.of(context)!.settings.arguments as ReadingDto,
        ),
    ContactsPickerPage.routeName: (context) => const ContactsPickerPage(),
    BooksPickerPage.routeName: (context) => const BooksPickerPage(),
    SettingsPage.routeName: (context) => const SettingsPage(),
    AboutPage.routeName: (context) => const AboutPage(),
  };

  /// Returns the initial route based on the user's authentication status.
  static String getInitialRoute(bool userIsLogged) {
    return userIsLogged ? RootPage.routeName : OnBoardingPage.routeName;
  }
}
