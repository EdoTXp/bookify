import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/bookcase_books_insertion/views/bookcase_books_insertion_page.dart';
import 'package:bookify/src/features/bookcase_detail/views/bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/features/root/views/root_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final routes = <String, WidgetBuilder>{
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
  BookcaseBooksInsertionPage.routeName: (context) => BookcaseBooksInsertionPage(
        bookcaseId: ModalRoute.of(context)!.settings.arguments as int,
      ),
};
