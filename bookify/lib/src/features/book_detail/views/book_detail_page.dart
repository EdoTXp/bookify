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
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isEllipsisText = true;
  final bookDetailController = BookDetailController();

  @override
  Widget build(BuildContext context) {
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
                  '${widget.book.title} ― ${widget.book.authors.join(', ')}',
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
                  bookImageUrl: widget.book.imageUrl,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.book.pageCount} PÁGINAS',
                    style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 14),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '9H PARA LER',
                    style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 14),
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
                          bookDetailController.launchUrl(widget.book.buyLink),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: /* BookifyElevatedButton(
                      text: 'Adicionar',
                      suffixIcon: Icons.arrow_forward,
                      onPressed: () {},
                    ),*/
                        BookifyElevatedButton(
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
                        averageRating: widget.book.averageRating,
                        ratingsCount: widget.book.ratingsCount,
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
                            title: 'Editora: ', content: widget.book.publisher),
                        BookDescriptionWidget(
                            title: 'Gêneros: ',
                            content: widget.book.categories.join(', '))
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
