import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/home/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BookBloc _bookBloc;
  late final TextEditingController _searchEC;

  @override
  void initState() {
    super.initState();
    _searchEC = TextEditingController();
    _bookBloc = context.read<BookBloc>()..add(GotAllBooksEvent());
  }

  @override
  void dispose() {
    _searchEC.dispose();
    super.dispose();
  }

  void _refreshPage() {
    _bookBloc.add(GotAllBooksEvent());
    _searchEC.clear();
  }

  Widget _getBookStateWidget(BuildContext context, BookState state) {
    return switch (state) {
      BooksLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      BookEmptyState() => Center(
          child: InfoItemStateWidget.withNotFoundState(
            message: 'Não foi encontrado nenhum livro com esses termos.',
            onPressed: _refreshPage,
          ),
        ),
      BooksLoadedState(:final books) => BooksLoadedStateWidget(
          books: books,
        ),
      BookErrorSate(errorMessage: final message) => Center(
          child: InfoItemStateWidget.withErrorState(
            message: message,
            onPressed: _refreshPage,
          ),
        ),
    };
  }

  void _onSubmittedSearch(String value, SearchType searchType) {
    if (value.isNotEmpty) {
      switch (searchType) {
        case SearchType.title:
          _bookBloc.add(FoundBooksByTitleEvent(title: value));
          break;
        case SearchType.author:
          _bookBloc.add(FoundBooksByAuthorEvent(author: value));
          break;
        case SearchType.category:
          _bookBloc.add(FoundBooksByCategoryEvent(category: value));
          break;
        case SearchType.publisher:
          _bookBloc.add(FoundBooksByPublisherEvent(publisher: value));
          break;
        case SearchType.isbn:
          _bookBloc.add(FoundBooksByIsbnEvent(isbn: value));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _refreshPage(),
      color: Theme.of(context).colorScheme.secondary,
      child: BlocBuilder<BookBloc, BookState>(
        bloc: _bookBloc,
        builder: (BuildContext context, state) {
          return Column(
            children: [
              if (state is BooksLoadedState)
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      right: 16.0,
                      left: 16.0,
                    ),
                    child: AnimatedSearchBar(
                      searchEC: _searchEC,
                      onSubmitted: _onSubmittedSearch,
                    ),
                  ),
                ),
              Expanded(
                child: _getBookStateWidget(context, state),
              ),
            ],
          );
        },
      ),
    );
  }
}
