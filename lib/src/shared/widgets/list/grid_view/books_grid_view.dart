import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BooksGridView extends StatelessWidget {
  final List<BookModel> books;
  final void Function(BookModel book) onTap;
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
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: .7,
            crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Tooltip(
                message: books[index].title,
                child: Material(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => onTap(books[index]),
                    child: BookWidget(
                      bookImageUrl: books[index].imageUrl,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
