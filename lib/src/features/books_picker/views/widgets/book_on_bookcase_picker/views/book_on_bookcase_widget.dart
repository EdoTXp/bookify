import 'package:bookify/src/features/books_picker/views/widgets/book_on_bookcase_picker/bloc/book_on_bookcase_picker_bloc.dart';
import 'package:bookify/src/features/books_picker/views/widgets/book_selector_widget/book_selector_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class BookOnBookcaseWidget extends StatefulWidget {
  final int bookcaseId;

  const BookOnBookcaseWidget({
    super.key,
    required this.bookcaseId,
  });

  @override
  State<BookOnBookcaseWidget> createState() => _BookOnBookcaseWidgetState();
}

class _BookOnBookcaseWidgetState extends State<BookOnBookcaseWidget> {
  late final BookOnBookcasePickerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookOnBookcasePickerBloc>()
      ..add(
        GotAllBookOnBookcasePickerEvent(
          bookcaseId: widget.bookcaseId,
        ),
      );
  }

  void _refreshPage() {
    _bloc.add(
      GotAllBookOnBookcasePickerEvent(
        bookcaseId: widget.bookcaseId,
      ),
    );
  }

  Widget _getWidgetOnBookOnBookcasePickerState(
      BuildContext context, BookOnBookcasePickerState state) {
    return switch (state) {
      BookOnBookcasePickerLoadingState() =>
        const CenterCircularProgressIndicator(),
      BookOnBookcasePickerEmptyState() => Center(
          child: Text(
            'empty-bookcase-or-not-contains-books-message'.i18n(),
            textAlign: TextAlign.center,
          ),
        ),
      BookOnBookcasePickerLoadedState(:final books) => BookSelectorWidget(
          books: books,
          onSelectBook: (book) => Navigator.pop(context, book),
        ),
      BookOnBookcasePickerErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'choose-book-title'.i18n(),
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: BlocBuilder<BookOnBookcasePickerBloc, BookOnBookcasePickerState>(
        bloc: _bloc,
        builder: _getWidgetOnBookOnBookcasePickerState,
      ),
    );
  }
}
