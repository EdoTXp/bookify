import 'package:bookify/src/features/bookcase_detail/bloc/bookcase_detail_bloc.dart';
import 'package:bookify/src/features/bookcase_detail/widgets/widgets.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/shared/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookcaseDetailPage extends StatefulWidget {
  final BookcaseModel bookcaseModel;

  const BookcaseDetailPage({
    super.key,
    required this.bookcaseModel,
  });

  @override
  State<BookcaseDetailPage> createState() => _BookcaseDetailPageState();
}

class _BookcaseDetailPageState extends State<BookcaseDetailPage> {
  late BookcaseModel _actualBookcase;
  late BookcaseDetailBloc _bloc;
  late bool _canPopPage;

  final _popupMenuItemsSet = {
    'Editar Estante',
    'Apagar Estante',
  };

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookcaseDetailBloc>();

    _actualBookcase = widget.bookcaseModel;

    _refreshPage();
    _canPopPage = true;
  }

  Widget _getWidgetOnBookcaseDetailState(
    BuildContext context,
    BookcaseDetailState state,
  ) {
    return switch (state) {
      BookcaseDetailLoadingState() ||
      BookcaseDetailDeletedState() =>
        const Center(child: CircularProgressIndicator()),
      BookcaseDetailBooksEmptyState() => BookcaseDetailEmptyStateWidget(
          bookcase: _actualBookcase,
          onTap: () {
            _refreshPage();
          },
        ),
      BookcaseDetailBooksLoadedState(:final books) =>
        BookcaseDetailLoadedStateWidget(
          books: books,
        ),
      BookcaseDetailErrorState(:final errorMessage) =>
        BookcaseDetailErrorStateWidget(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  Future<void> _handleBookcaseDetailsStateListener(
      BookcaseDetailState state, BuildContext context) async {
    if (state is BookcaseDetailDeletedState) {
      setState(() {
        _canPopPage = false;
      });

      SnackbarService.showSnackBar(
        context,
        'Estante removida com sucesso.\nAguarde até voltar à página anterior',
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2))
          .then((_) => Navigator.of(context).pop());
    }
  }

  void _refreshPage() {
    _bloc.add(GotBookcaseBooksEvent(bookcaseId: _actualBookcase.id!));
  }

  Future<void> _popupMenuOnSeleceted(String value, BuildContext context) async {
    if (value == _popupMenuItemsSet.first) {
      final BookcaseModel? bookcaseUpdated;

      bookcaseUpdated = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookcaseInsertionPage(
            bookcaseModel: _actualBookcase,
          ),
        ),
      );

      if (bookcaseUpdated != null) {
        setState(() {
          _actualBookcase = bookcaseUpdated!;
        });
      }
    } else {
      // Ask the user for confirmation before deleting the bookcase
      await ShowDialogService.show(
        context: context,
        title: 'Deletar a estante',
        content:
            'Clicando em "CONFIRMAR" você removerá a estante ${_actualBookcase.name}.\nTem Certeza?',
        cancelButtonFunction: () => Navigator.of(context).pop(),
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
                    await _popupMenuOnSeleceted(value, context),
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
          body: _getWidgetOnBookcaseDetailState(context, state),
        ),
      ),
    );
  }
}
