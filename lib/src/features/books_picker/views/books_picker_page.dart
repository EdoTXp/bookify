import 'package:bookify/src/features/books_picker/views/widgets/bookcase_picker/views/bookcase_picker_widget.dart';
import 'package:bookify/src/features/books_picker/views/widgets/separate_books_picker/views/separate_books_picker_widget.dart';
import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BooksPickerPage extends StatefulWidget {
  /// The Route Name = '/books_picker'
  static const routeName = '/books_picker';

  const BooksPickerPage({super.key});

  @override
  State<BooksPickerPage> createState() => _BooksPickerPageState();
}

class _BooksPickerPageState extends State<BooksPickerPage> {
  late String title;
  bool isSelectionBook = false;

  @override
  void initState() {
    super.initState();
    _setTitle(isSelectionBook);
  }

  void _setTitle(bool value) {
    title = value
        ? 'select-book-separately-title'.i18n()
        : 'select-bookcase-title'.i18n();
  }

  void _onSelectBook(BookModel book) {
    Navigator.pop(context, book);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Switch.adaptive(
              key: const Key('Bookcase / Book Switch'),
              value: isSelectionBook,
              onChanged: (value) {
                setState(() {
                  isSelectionBook = value;
                  _setTitle(value);
                });
              },
              activeThumbColor: colorScheme.secondary,
              inactiveThumbColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.primary.withValues(
                alpha: .5,
              ),
              thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Icon(
                      Icons.book_rounded,
                      color: Colors.white,
                    );
                  }
                  return const Icon(
                    BookifyIcons.bookcase,
                    color: Colors.white,
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: !isSelectionBook
          ? BookcasePickerWidget(onSelectBookModel: _onSelectBook)
          : SeparateBooksPickerWidget(onSelectBookModel: _onSelectBook),
    );
  }
}
