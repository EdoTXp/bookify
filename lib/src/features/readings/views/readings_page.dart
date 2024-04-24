import 'dart:async';

import 'package:bookify/src/features/books_picker/views/books_picker_page.dart';
import 'package:bookify/src/features/readings/bloc/readings_bloc.dart';
import 'package:bookify/src/features/readings/views/widgets/readings_loaded_state_widget.dart';
import 'package:bookify/src/features/readings_insertion/views/readings_insertion_page.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  late final ReadingsBloc _bloc;
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  late bool _searchBarIsVisible;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _searchBarIsVisible = false;

    _bloc = context.read<ReadingsBloc>()
      ..add(
        GotAllReadingsEvent(),
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _refreshPage() {
    _bloc.add(
      GotAllReadingsEvent(),
    );
  }

  Widget _getWidgetOnReadingsState(BuildContext context, ReadingsState state) {
    return switch (state) {
      ReadingsLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      ReadingsEmptyState() => Center(
          child: ItemEmptyStateWidget(
            label: 'Iniciar uma nova leitura',
            onTap: () => _insertNewReading(context),
          ),
        ),
      ReadingsNotFoundState() => Center(
          child: InfoItemStateWidget.withNotFoundState(
            message:
                'Nenhuma Leitura encontrada com esses termos.\nVerifique se foi digitado o título do livro corretamente.',
            onPressed: () {
              _searchController.clear();

              _toggleSearchBarVisible();
              _refreshPage();
            },
          ),
        ),
      ReadingsLoadedState(:final readingsDto) => ReadingsLoadedStateWidget(
          readingsDto: readingsDto,
          onNewReading: () => _insertNewReading(context),
        ),
      ReadingsErrorState(:final errorMessage) => Center(
          child: InfoItemStateWidget.withErrorState(
            message: errorMessage,
            onPressed: _refreshPage,
          ),
        ),
    };
  }

  Future<void> _insertNewReading(BuildContext context) async {
    final book = await showModalBottomSheet<BookModel?>(
      context: context,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const BooksPickerPage(),
    );

    if (book != null && context.mounted) {
      await Navigator.of(context).pushNamed(
        ReadingsInsertionPage.routeName,
        arguments: book,
      );

      _refreshPage();
    }
  }

  void _toggleSearchBarVisible() {
    setState(() {
      _searchBarIsVisible = !_searchBarIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Offstage(
          offstage: !_searchBarIsVisible,
          child: TextField(
            focusNode: _focusNode,
            controller: _searchController,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Digite o  título do livro em leitura.',
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 14),
            onTapOutside: (_) => _focusNode.unfocus(),
            onChanged: (_) {
              _bloc.add(
                _searchController.text.length >= 3
                    ? FindedReadingByBookTitleEvent(
                        searchQueryName: _searchController.text,
                      )
                    : GotAllReadingsEvent(),
              );
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: colorScheme.primary.withOpacity(.75),
            ),
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: _searchController,
            builder: (context, value, _) {
              if (value.text.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Apagar o texto.',
                  onPressed: _searchController.clear,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: Icon(
              (_searchBarIsVisible)
                  ? Icons.search_off_rounded
                  : Icons.search_rounded,
            ),
            tooltip: (_searchBarIsVisible)
                ? 'Desativar a barra de pesquisa.'
                : 'Ativar a barra de pesquisa.',
            onPressed: () {
              if (_searchBarIsVisible) {
                _searchController.clear();
                _focusNode.unfocus();
              } else {
                _focusNode.requestFocus();
              }
              _toggleSearchBarVisible();
            },
          ),
        ],
      ),
      body: BlocBuilder<ReadingsBloc, ReadingsState>(
        bloc: _bloc,
        builder: _getWidgetOnReadingsState,
      ),
    );
  }
}
