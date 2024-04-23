import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/add_new_item_text_button.dart';
import 'package:bookify/src/shared/widgets/list/selected_item_row/selected_item_row.dart';
import 'package:flutter/material.dart';

class BookcaseDetailLoadedStateWidget extends StatefulWidget {
  final List<BookModel> books;
  final VoidCallback onAddBooksPressed;
  final void Function(List<BookModel> books) onDeletedBooksPressed;

  const BookcaseDetailLoadedStateWidget({
    super.key,
    required this.books,
    required this.onAddBooksPressed,
    required this.onDeletedBooksPressed,
  });

  @override
  State<BookcaseDetailLoadedStateWidget> createState() =>
      _BookcaseDetailLoadedStateWidgetState();
}

class _BookcaseDetailLoadedStateWidgetState
    extends State<BookcaseDetailLoadedStateWidget> {
  bool _isSelectionMode = false;
  late final List<BookModel> _selectedList;

  @override
  void initState() {
    _selectedList = [];
    super.initState();
  }

  Future<void> _normalOnTap(BuildContext context, BookModel book) async {
    await Navigator.pushNamed(
      context,
      BookDetailPage.routeName,
      arguments: book,
    );
  }

  void _onTap({required BuildContext context, required BookModel element}) {
    if (_isSelectionMode) {
      setState(() {
        !_selectedList.contains(element)
            ? _selectedList.add(element)
            : _selectedList.remove(element);

        _setIsSelectedMode();
      });
    } else {
      _normalOnTap(context, element);
    }
  }

  void _onLongPress({required BookModel element}) {
    setState(() {
      if (!_selectedList.contains(element)) {
        _selectedList.add(element);
      } else {
        _selectedList.remove(element);
      }

      _setIsSelectedMode();
    });
  }

  void _setIsSelectedMode() {
    _isSelectionMode = _selectedList.isNotEmpty;
  }

  void _selectAllItems(List<BookModel> books) {
    setState(() {
      _selectedList.replaceRange(
        0,
        _selectedList.length,
        books,
      );
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedList.clear();
      _setIsSelectedMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final books = widget.books;

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: (_isSelectionMode)
              ? SelectedItemRow(
                  itemQuantity: _selectedList.length,
                  itemLabelSingular: 'Livro',
                  itemLabelPlural: 'Livros',
                  onSelectedAll: (isSelectedAll) => (isSelectedAll)
                      ? _selectAllItems(books)
                      : _clearSelection(),
                  onPressedDeleteButton: () {
                    ShowDialogService.show(
                      context: context,
                      title: 'Deletar Livros',
                      content:
                          'Clicando em "CONFIRMAR" você removerá os livros.\nTem Certeza?',
                      confirmButtonFunction: () {
                        Navigator.of(context).pop();
                        widget.onDeletedBooksPressed(_selectedList);
                      },
                    );
                  },
                )
              : AddNewItemTextButton(
                  label: 'Adicionar novos livros',
                  onPressed: widget.onAddBooksPressed,
                ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectedList.isNotEmpty ? _clearSelection() : null,
            child: OrientationBuilder(
              builder: (context, orientation) {
                return GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: .7,
                    crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () => _onTap(
                            context: context,
                            element: books[index],
                          ),
                          onLongPress: () =>
                              _onLongPress(element: books[index]),
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
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
