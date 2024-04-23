import 'dart:async';

import 'package:bookify/src/features/readings/bloc/readings_bloc.dart';
import 'package:bookify/src/features/readings/views/widgets/readings_loaded_state_widget.dart';
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

  Timer? _checkTypingEndTimer;

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
    _checkTypingEndTimer?.cancel();
    super.dispose();
  }

  Widget _getWidgetOnReadingsState(BuildContext context, ReadingsState state) {
    return switch (state) {
      ReadingsLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      ReadingsEmptyState() => Center(
          child: ItemEmptyStateWidget(
            label: 'Iniciar uma nova leitura',
            onTap: _refreshPage,
          ),
        ),
      ReadingsNotFoundState() => Center(
          child: InfoItemStateWidget.withNotFoundState(
            message:
                'Nenhuma Leitura encontrada com esses termos.\nVerifique se foi digitado o título do livro corretamente.',
            onPressed: () {
              _searchController.clear();
              _refreshPage();
            },
          ),
        ),
      ReadingsLoadedState(:final readingsDto) => ReadingsLoadedStateWidget(
          readingsDto: readingsDto,
          refreshPage: _refreshPage,
        ),
      ReadingsErrorState(:final errorMessage) => Center(
          child: InfoItemStateWidget.withErrorState(
            message: errorMessage,
            onPressed: _refreshPage,
          ),
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(
      GotAllReadingsEvent(),
    );
  }

  void _startTimer() {
    _checkTypingEndTimer = Timer(const Duration(milliseconds: 600), () {
      _bloc.add(
        _searchController.text.length >= 3
            ? FindedReadingByBookTitleEvent(
                searchQueryName: _searchController.text,
              )
            : GotAllReadingsEvent(),
      );
    });
  }

  void _resetTimer() {
    _checkTypingEndTimer?.cancel();
    _startTimer();
  }

  void _toggleSearchBarVisible() {
    setState(() {
      _searchBarIsVisible = !_searchBarIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingsBloc, ReadingsState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: state is ReadingsLoadedState
              ? AppBar(
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
                      onChanged: (_) => _resetTimer(),
                    ),
                  ),
                  actions: [
                    Visibility(
                      visible: (_searchBarIsVisible &&
                          _searchController.text.isNotEmpty),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        tooltip: 'Apagar o texto.',
                        onPressed: _searchController.clear,
                      ),
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
                )
              : null,
          body: _getWidgetOnReadingsState(
            context,
            state,
          ),
        );
      },
    );
  }
}
