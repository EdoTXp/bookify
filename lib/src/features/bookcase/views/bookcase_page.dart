import 'package:bookify/src/features/bookcase/views/widgets/bookcase_loaded_state_widget/bookcase_loaded_state_widget.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

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

    _bloc = context.read<BookcaseBloc>()..add(GotAllBookcasesEvent());
  }

  @override
  void didUpdateWidget(covariant BookcasePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final actualSearchQuery = widget.searchQuery;
    final oldSearchQuery = oldWidget.searchQuery;

    if (actualSearchQuery == null && oldSearchQuery != null) {
      _refreshPage();
      return;
    }

    if (actualSearchQuery != null) {
      _bloc.add(
        FoundBookcaseByNameEvent(
          searchQueryName: actualSearchQuery,
        ),
      );
    }
  }

  void _refreshPage() {
    _bloc.add(GotAllBookcasesEvent());
  }

  Widget _getWidgetOnBookcaseState(BuildContext context, BookcaseState state) {
    return switch (state) {
      BookcaseLoadingState() => const CenterCircularProgressIndicator(),
      BookcaseEmptyState() => Center(
          child: ItemEmptyStateWidget(
            key: const Key('Bookcase Empty State'),
            label: 'create-new-bookcase-button'.i18n(),
            onTap: () async => await _onAddNewBookcase(),
          ),
        ),
      BookcaseLoadedState(bookcasesDto: final bookcasesDto) =>
        BookcaseLoadedStateWidget(
          key: const Key('Bookcase Loaded State'),
          bookcasesDto: bookcasesDto,
          onRefresh: _refreshPage,
          onPressedDeleteButton: (selectedList) => _bloc.add(
            DeletedBookcasesEvent(
              selectedList: selectedList,
            ),
          ),
        ),
      BookcaseNotFoundState() => InfoItemStateWidget.withNotFoundState(
          message: 'bookcase-not-found-whit-this-terms'.i18n(),
          onPressed: _refreshPage,
        ),
      BookcaseErrorState(errorMessage: final message) =>
        InfoItemStateWidget.withErrorState(
          message: message,
          onPressed: _refreshPage,
        ),
    };
  }

  Future<void> _onAddNewBookcase() async {
    var bookcaseInsertionList = await Navigator.pushNamed(
      context,
      BookcaseInsertionPage.routeName,
    ) as List<Object?>?;

    final isInserted = bookcaseInsertionList?[0] as bool?;

    if (isInserted != null && isInserted) {
      _refreshPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookcaseBloc, BookcaseState>(
      bloc: _bloc,
      builder: _getWidgetOnBookcaseState,
    );
  }
}
