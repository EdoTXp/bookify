import 'package:bookify/src/features/book/models/book_model.dart';
import 'package:flutter/material.dart';

import '../buttons/book_button.dart';

class BooksGridView extends StatefulWidget {
  final List<BookModel> books;
  final void Function() onTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const BooksGridView({
    super.key,
    required this.books,
    required this.onTap,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<BooksGridView> createState() => _BooksGridViewState();
}

class _BooksGridViewState extends State<BooksGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: .7, crossAxisCount: 3),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            message: widget.books[index].title,
            child: BookButton(
              bookUrl: widget.books[index].imageUrl,
              onTap: () {
                setState(() {
                  widget.onTap;
                });
              },
            ),
          ),
        );
      },
    );
  }
}
