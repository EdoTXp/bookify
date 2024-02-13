import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/features/bookcase/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BookcasePage extends StatefulWidget {
  final String? searchQuery;

  const BookcasePage({
    super.key,
    this.searchQuery,
  });

  @override
  State<BookcasePage> createState() => _BookcasePageState();
}

class _BookcasePageState extends State<BookcasePage> {
  late BookcaseBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<BookcaseBloc>();
    _refreshPage();
  }

  @override
  void didUpdateWidget(covariant BookcasePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchQuery == null) return;

    if (widget.searchQuery != oldWidget.searchQuery) {
      _bloc.add(
        FindedBookcaseByNameEvent(
          searchQueryName: widget.searchQuery!,
        ),
      );
    }
  }

  Widget _getWidgetOnBookcaseState(BuildContext context, BookcaseState state) {
    return switch (state) {
      BookcaseLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      BookcaseEmptyState() => Center(
          child: ItemEmptyStateWidget(
            label: 'Criar uma nova estante',
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const BookcaseInsertionPage()),
              );
              _refreshPage();
            },
          ),
        ),
      BookcaseLoadedState(bookcasesDto: final bookcasesDto) =>
        BookcaseLoadedStateWidget(
          bookcasesDto: bookcasesDto,
          onRefresh: _refreshPage,
          onPressedDeleteButton: (selectedList) =>
              _bloc.add(DeletedBookcasesEvent(selectedList: selectedList)),
        ),
      BookcaseNotFoundState() => InfoItemStateWidget.withNotFoundState(
          message: 'Nenhuma Estante encontrada com esses termos.',
          onPressed: _refreshPage,
        ),
      BookcaseErrorState(errorMessage: final message) =>
        InfoItemStateWidget.withErrorState(
          message: message,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(GotAllBookcasesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookcaseBloc, BookcaseState>(
      bloc: _bloc,
      builder: _getWidgetOnBookcaseState,
    );
  }
}
