import 'package:bookify/src/features/books_picker/views/widgets/book_selector_widget/widgets/book_selection_row.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BookSelectorWidget extends StatefulWidget {
  final List<BookModel> books;
  final void Function(BookModel book) onSelectBook;

  const BookSelectorWidget({
    super.key,
    required this.books,
    required this.onSelectBook,
  });

  @override
  State<BookSelectorWidget> createState() => _BookSelectorWidgetState();
}

class _BookSelectorWidgetState extends State<BookSelectorWidget> {
  BookModel? selectedBook;
  int selectedIndex = -1;
  bool isSelectedMode = false;

  void _clearData() {
    setState(() {
      selectedBook = null;
      selectedIndex = -1;
      isSelectedMode = false;
    });
  }

  void _clickOnBook(BookModel contactDto, int index) {
    if (selectedBook != null) {
      setState(() {
        selectedBook = contactDto;
        selectedIndex = index;
        isSelectedMode = true;
      });
      return;
    }
    setState(() {
      selectedBook = contactDto;
      selectedIndex = index;
      isSelectedMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (isSelectedMode) ...[
            BookSelectedRow(
              onClearPressed: _clearData,
              onConfirmPressed: () => selectedBook != null
                  ? widget.onSelectBook(selectedBook!)
                  : null,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
          Expanded(
            child: GestureDetector(
              onTap: () => selectedBook != null ? _clearData() : null,
              child: GridView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: widget.books.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: .7,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Tooltip(
                      message: widget.books[index].title,
                      child: Material(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => _clickOnBook(widget.books[index], index),
                          child: (selectedBook == widget.books[index])
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
                                    bookImageUrl: widget.books[index].imageUrl,
                                  ),
                                )
                              : BookWidget(
                                  bookImageUrl: widget.books[index].imageUrl,
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
      ),
    );
  }
}
