import 'package:bookify/src/shared/models/book_model.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class SingleBookLoadedStateWidget extends StatelessWidget {
  final BookModel book;

  const SingleBookLoadedStateWidget({
    required this.book,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      //TODO Creare una pagina di navigazione quando c'è solo un libro

      child: RoundedBoxChoiceChip(
        label: book.title,
        onSelected: (value) {},
      ),
    );
  }
}
