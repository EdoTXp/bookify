import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/grid_view/books_grid_view.dart';
import 'package:flutter/material.dart';

class BookcaseDetailLoadedStateWidget extends StatelessWidget {
  final List<BookModel> books;
  final VoidCallback onPressed;

  const BookcaseDetailLoadedStateWidget({
    super.key,
    required this.books,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: TextButton.icon(
            onPressed: onPressed,
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: colorScheme.secondary,
            ),
            label: const Text('Adicionar novos livros'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: BooksGridView(
              books: books,
              onTap: (book) {
                Navigator.pushNamed(
                  context,
                  BookDetailPage.routeName,
                  arguments: book,
                );
              }),
        ),
      ],
    );
  }
}
