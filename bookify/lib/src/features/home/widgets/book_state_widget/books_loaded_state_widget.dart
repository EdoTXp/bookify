import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter/material.dart';
import '../../../book_detail/views/book_detail_page.dart';
import '../widgets.dart';

class BooksLoadedStateWidget extends StatelessWidget {
  final List<BookModel> books;
  final ScrollController? controller;

  const BooksLoadedStateWidget({
    required this.books,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, right: 16.0, left: 16.0, bottom: 16.0),
      child: BooksGridView(
        shrinkWrap: true,
        controller: controller,
        books: books,
        onTap: (book) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        ),
      ),
    );
  }
}
