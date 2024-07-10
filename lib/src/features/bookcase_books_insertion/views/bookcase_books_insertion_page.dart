import 'package:bookify/src/features/bookcase_books_insertion/widgets/bookcase_books_insertion_loaded_state_widget/bookcase_books_insertion_loaded_state.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/bookcase_books_insertion/bloc/bookcase_books_insertion_bloc.dart';
import 'package:bookify/src/features/bookcase_books_insertion/widgets/widgets.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
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
  late final BookcaseBooksInsertionBloc _bloc;
  late bool _canPop;

  @override
  void initState() {
    _bloc = context.read<BookcaseBooksInsertionBloc>()
      ..add(
        GotAllBooksForThisBookcaseEvent(
          bookcaseId: widget.bookcaseId,
        ),
      );
    _canPop = true;
    super.initState();
  }

  Widget _getWidgetOnBookcaseBooksInsertionState(
    BuildContext context,
    BookcaseBooksInsertionState state,
  ) {
    return switch (state) {
      BookcaseBooksInsertionLoadingState() ||
      BookcaseBooksInsertionInsertedState() =>
        const CenterCircularProgressIndicator(),
      BookcaseBooksInsertionEmptyState(:final message) => Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      BookcaseBooksInsertionLoadedState(:final books) =>
        BookcaseBooksInsertionLoadedStateWidget(
          key: const Key('Bookcase Books Insertion LoadedState Widget'),
          books: books,
          onSelectedBooks: (selectedBook) {
            _bloc.add(
              InsertBooksOnBookcaseEvent(
                bookcaseId: widget.bookcaseId,
                books: selectedBook,
              ),
            );
          },
        ),
      BookcaseBooksInsertionErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _handleBookcaseInsertionState(
    BuildContext context,
    BookcaseBooksInsertionState state,
  ) async {
    if (state is BookcaseBooksInsertionInsertedState) {
      setState(() {
        _canPop = false;
      });

      SnackbarService.showSnackBar(
        context,
        'Livro adicionado. Aguarde até voltar à página anterior.',
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2)).then(
        (_) => Navigator.of(context).pop(true),
      );
    }
  }

  void _refreshPage() {
    _bloc.add(
      GotAllBooksForThisBookcaseEvent(
        bookcaseId: widget.bookcaseId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      child:
          BlocConsumer<BookcaseBooksInsertionBloc, BookcaseBooksInsertionState>(
              bloc: _bloc,
              listener: _handleBookcaseInsertionState,
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: const Text(
                      'Selecione os livros',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        _getWidgetOnBookcaseBooksInsertionState(context, state),
                  ),
                );
              }),
    );
  }
}
