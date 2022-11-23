import 'package:bookify/src/features/book/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  var isElipsed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '${widget.book.title} - ${widget.book.authors.join(', ')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  height: 500,
                  width: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.book.imageUrl),
                        fit: BoxFit.fill),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
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
                        fontSize: 16),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '9H HORAS PARA LER',
                    style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Sinopse',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => setState(() => isElipsed = !isElipsed),
                child: Text(
                  widget.book.description,
                  maxLines: (isElipsed) ? 4 : null,
                  overflow: (isElipsed)
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  strutStyle: const StrutStyle(height: 2),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Avaliações',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Text(
                    '${widget.book.averageRating}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: widget.book.averageRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    itemSize: 20,
                  ),
                  Text(
                    'TOTAL: ${widget.book.ratingsCount}',
                    style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
