import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/features/book_detail/widgets/widgets.dart';
import 'package:bookify/src/features/book_detail/controllers/book_detail_controller.dart';

/// Page where it shows the details of a book.
class BookDetailPage extends StatefulWidget {
  final BookModel book;

  /// Required parameters BookModel book
  const BookDetailPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isEllipsisText = true;
  final bookDetailController = BookDetailController();

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final authors =
        book.authors.map((author) => author.name).toList().join(', ');
    final categories =
        book.categories.map((category) => category.name).toList().join(', ');

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 24.0, right: 24.0, top: 8.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '${book.title} ― $authors',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: BookWidget(
                  height: 300,
                  width: 200,
                  bookImageUrl: book.imageUrl,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${book.pageCount} PÁGINAS',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '9H PARA LER',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BookifyOutlinedButton(
                      text: 'Ir para loja',
                      suffixIcon: Icons.store,
                      onPressed: () async =>
                          bookDetailController.launchUrl(book.buyLink),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BookifyElevatedButton(
                        onPressed: () {},
                        suffixIcon: Icons.arrow_forward,
                        text: 'Adicionar'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Sinopse',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => setState(() => isEllipsisText = !isEllipsisText),
                child: Text(
                  widget.book.description,
                  maxLines: (isEllipsisText) ? 4 : null,
                  textAlign: TextAlign.justify,
                  overflow: (isEllipsisText)
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Avaliações',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      BookRating(
                        averageRating: book.averageRating,
                        ratingsCount: book.ratingsCount,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações do Livro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        BookDescriptionWidget(
                            title: 'Editora: ', content: book.publisher),
                        BookDescriptionWidget(
                            title: 'Gêneros: ', content: categories),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
