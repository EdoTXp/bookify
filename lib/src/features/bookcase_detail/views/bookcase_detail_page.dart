import 'package:bookify/src/features/bookcase_books_insertion/views/bookcase_books_insertion_page.dart';
import 'package:bookify/src/features/bookcase_detail/bloc/bookcase_detail_bloc.dart';
import 'package:bookify/src/features/bookcase_detail/widgets/widgets.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

///Page where you can show the details of the [BookcaseModel] and the books that are part of it.
///
///On this page you can view the details of the [bookcaseModel],
/// its books, edit or remove the bookcase, add or remove books.
class BookcaseDetailPage extends StatefulWidget {
  /// The Route Name = '/bookcase_detail'
  static const routeName = '/bookcase_detail';
  final BookcaseModel bookcaseModel;

  const BookcaseDetailPage({
    super.key,
    required this.bookcaseModel,
  });

  @override
  State<BookcaseDetailPage> createState() => _BookcaseDetailPageState();
}

class _BookcaseDetailPageState extends State<BookcaseDetailPage> {
  /// It receives the bookcases from the constructor and will be updated if an updated bookcase returns from the bookcase editing page.
  late BookcaseModel _actualBookcase;

  /// Variable that gives permission to return to the previous page.
  ///
  ///It will start with [True] when the [initState] is called and will become [False],
  /// when the state of the [_bloc] is on [BookcaseDetailDeletedState].
  late bool _canPopPage;
  late BookcaseDetailBloc _bloc;

  /// Set of menu items that appear in the popup menu for bookcase options.
  final _popupMenuItemsSet = {
    'edit-bookcase-title'.i18n(),
    'remove-bookcase-title'.i18n(),
  };

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookcaseDetailBloc>();

    _actualBookcase = widget.bookcaseModel;

    _refreshPage();
    _canPopPage = true;
  }

  /// Returns a widget based on the current state of the bookcase detail Page.
  Widget _getWidgetOnBookcaseDetailState(
    BuildContext context,
    BookcaseDetailState state,
  ) {
    return switch (state) {
      BookcaseDetailLoadingState() ||
      BookcaseDetailDeletedState() =>
        const CenterCircularProgressIndicator(),
      BookcaseDetailBooksEmptyState() => ItemEmptyStateWidget(
          key: const Key('Bookcase Detail Books Empty State'),
          label: 'add-new-books-button'.i18n(),
          onTap: () async => await _addNewBooksBottomSheet(),
        ),
      BookcaseDetailBooksLoadedState(:final books) =>
        BookcaseDetailLoadedStateWidget(
          books: books,
          bookcaseId: _actualBookcase.id!,
          refreshPage: _refreshPage,
          onAddBooksPressed: () async => await _addNewBooksBottomSheet(),
          onDeletedBooksPressed: (books) => _bloc.add(
            DeletedBooksOnBookcaseEvent(
              bookcaseId: _actualBookcase.id!,
              books: books,
            ),
          ),
        ),
      BookcaseDetailErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  Future<void> _addNewBooksBottomSheet() async {
    bool? booksIsAdded = false;

    booksIsAdded = await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isScrollControlled: true,
      builder: (_) => BookcaseBooksInsertionPage(
        bookcaseId: _actualBookcase.id!,
      ),
    );

    if (booksIsAdded != null && booksIsAdded) {
      _refreshPage();
    }
  }

  /// Listen to the Bookcase based on the current state.
  ///
  /// When the state is [BookcaseDetailDeletedState], the [PopScope] through [_canPopPage] will be disabled.
  /// Next, a snackbar will be shown with the success message and after 2 seconds, return to the previous page.
  ///
  /// **Note**: If there is an error removing the [_bookcase], the state will always be [BookcaseDetailErrorState].
  Future<void> _handleBookcaseDetailsStateListener(
      BookcaseDetailState state, BuildContext context) async {
    if (state is BookcaseDetailDeletedState) {
      setState(() {
        _canPopPage = false;
      });

      SnackbarService.showSnackBar(
        context,
        'bookcase-successfully-removed-snackbar'.i18n(),
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2)).then(
        (_) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    }
  }

  void _refreshPage() {
    _bloc.add(GotBookcaseBooksEvent(bookcaseId: _actualBookcase.id!));
  }

  Future<void> _popupMenuOnSelected(String value, BuildContext context) async {
    if (value == _popupMenuItemsSet.first) {
      var bookcaseList = await Navigator.pushNamed(
        context,
        BookcaseInsertionPage.routeName,
        arguments: _actualBookcase,
      ) as List<Object?>?;

      final bookcaseUpdated = bookcaseList?[1] as BookcaseModel?;

      if (bookcaseUpdated != null) {
        setState(() {
          _actualBookcase = bookcaseUpdated;
        });
      }
    } else {
      // Ask the user for confirmation before deleting the bookcase
      await ShowDialogService.showAlertDialog(
        context: context,
        title: 'delete-bookcase-title'.i18n(),
        content: 'delete-bookcase-description'.i18n([_actualBookcase.name]),
        confirmButtonFunction: () {
          _bloc.add(
            DeletedBookcaseEvent(bookcaseId: _actualBookcase.id!),
          );
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopPage,
      child: BlocConsumer<BookcaseDetailBloc, BookcaseDetailState>(
        listener: (context, state) async {
          await _handleBookcaseDetailsStateListener(state, context);
        },
        bloc: _bloc,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) async =>
                    await _popupMenuOnSelected(value, context),
                itemBuilder: (context) {
                  return _popupMenuItemsSet.map(
                    (String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ).toList();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (state is BookcaseDetailBooksEmptyState ||
                    state is BookcaseDetailBooksLoadedState) ...[
                  BookcaseDescriptionWidget(
                    name: _actualBookcase.name,
                    description: _actualBookcase.description,
                    color: _actualBookcase.color,
                    booksQuantity: (state is BookcaseDetailBooksLoadedState)
                        ? state.books.length
                        : 0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                Expanded(
                  child: _getWidgetOnBookcaseDetailState(context, state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
