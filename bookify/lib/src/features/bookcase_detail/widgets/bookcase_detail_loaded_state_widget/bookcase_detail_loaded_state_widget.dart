import 'package:bookify/src/shared/models/book_model.dart';

import 'package:flutter/material.dart';

class BookcaseDetailLoadedStateWidget extends StatelessWidget {
  final List<BookModel> books;

  const BookcaseDetailLoadedStateWidget({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
