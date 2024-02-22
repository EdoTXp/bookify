import 'package:flutter/material.dart';

class BookcaseBooksInsertionPage extends StatefulWidget {

  static const routeName = '/bookcase_book_insertion';
  
  final int bookcaseId;

  const BookcaseBooksInsertionPage({
    super.key,
    required this.bookcaseId,
  });

  @override
  State<BookcaseBooksInsertionPage> createState() =>
      _BookcaseBooksInsertionPageState();
}

class _BookcaseBooksInsertionPageState
    extends State<BookcaseBooksInsertionPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Selecione os livros.', style: TextStyle(fontSize: 16),),
      ),
      body: Container(),
    );
  }
}
