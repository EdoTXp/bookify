import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/bookcase_books_insertion/views/bookcase_books_insertion_page.dart';
import 'package:bookify/src/features/bookcase_detail/views/bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/features/books_picker/views/books_picker_page.dart';
import 'package:bookify/src/features/contacts_picker/views/contacts_picker_page.dart';
import 'package:bookify/src/features/loan_detail/views/loan_detail_page.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/features/readings_insertion/views/readings_insertion_page.dart';
import 'package:bookify/src/features/root/views/root_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    RootPage.routeName: (context) => const RootPage(),
    BookDetailPage.routeName: (context) => BookDetailPage(
          bookModel: ModalRoute.of(context)!.settings.arguments as BookModel,
        ),
    QrCodeScannerPage.routeName: (context) => const QrCodeScannerPage(),
    BookcaseDetailPage.routeName: (context) => BookcaseDetailPage(
          bookcaseModel:
              ModalRoute.of(context)!.settings.arguments as BookcaseModel,
        ),
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
    ContactsPickerPage.routeName: (context) => const ContactsPickerPage(),
    BooksPickerPage.routeName: (context) => const BooksPickerPage(),
  };

  static String initialRoute = RootPage.routeName;

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
