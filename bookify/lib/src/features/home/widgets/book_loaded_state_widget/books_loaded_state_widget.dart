import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/list/grid_view/books_grid_view.dart';
import 'package:flutter/material.dart';

class BooksLoadedStateWidget extends StatelessWidget {
  final List<BookModel> books;

  const BooksLoadedStateWidget({
    required this.books,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, right: 16.0, left: 16.0, bottom: 16.0),
      child: BooksGridView(
        books: books,
        onTap: (book) => Navigator.pushNamed(
          context,
          BookDetailPage.routeName,
          arguments: book,
        ),
      ),
    );
  }
}
