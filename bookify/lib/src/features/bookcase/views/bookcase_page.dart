import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/widgets/empty_item_widget/empty_item_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/features/bookcase/views/widgets/bookcase_states_widget.dart';
import 'package:flutter/material.dart';

class BookcasePage extends StatefulWidget {
  const BookcasePage({super.key});

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

  Widget _getWidgetOnBookcaseState(BuildContext context, BookcaseState state) {
    return switch (state) {
      BookcaseLoadingState() =>
        const Center(child: CircularProgressIndicator()),
      BookcaseEmptyState() => Center(
          child: EmptyItemWidget(
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
      BookcaseErrorState(errorMessage: final message) =>
        BookcaseErrorStateWidget(message: message, onPressed: _refreshPage),
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
