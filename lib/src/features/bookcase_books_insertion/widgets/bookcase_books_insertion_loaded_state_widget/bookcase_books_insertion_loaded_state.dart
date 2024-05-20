import 'package:bookify/src/features/bookcase_books_insertion/widgets/books_selected_row/books_selected_row.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BookcaseBooksInsertionLoadedStateWidget extends StatefulWidget {
  final List<BookModel> books;
  final void Function(List<BookModel> selectedBook) onSelectedBooks;

  const BookcaseBooksInsertionLoadedStateWidget({
    super.key,
    required this.books,
    required this.onSelectedBooks,
  });

  @override
  State<BookcaseBooksInsertionLoadedStateWidget> createState() =>
      _BookcaseBooksInsertionLoadedStateWidgetState();
}

class _BookcaseBooksInsertionLoadedStateWidgetState
    extends State<BookcaseBooksInsertionLoadedStateWidget> {
  bool _isSelectionMode = false;
  late final List<BookModel> _selectedList;

  @override
  void initState() {
    _selectedList = [];
    super.initState();
  }

  void _onTap(BookModel book) {
    setState(() {
      !_selectedList.contains(book)
          ? _selectedList.add(book)
          : _selectedList.remove(book);

      _setIsSelectedMode();
    });
  }

  void _setIsSelectedMode() {
    _isSelectionMode = _selectedList.isNotEmpty;
  }

  void _clearSelection() {
    setState(() {
      _selectedList.clear();
      _setIsSelectedMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = widget.books;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (_isSelectionMode) ...[
          BooksSelectedRow(
            booksQuantity: _selectedList.length,
            onClearPressed: _clearSelection,
            onConfirmPressed: () => widget.onSelectedBooks(_selectedList),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        Expanded(
          child: GestureDetector(
            onTap: () => _selectedList.isNotEmpty ? _clearSelection() : null,
            child: GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .7,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Tooltip(
                    message: books[index].title,
                    child: Material(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () => _onTap(books[index]),
                        child: (_selectedList.contains(books[index]))
                            ? Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: BookWidget(
                                  bookImageUrl: books[index].imageUrl,
                                ),
                              )
                            : BookWidget(
                                bookImageUrl: books[index].imageUrl,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
