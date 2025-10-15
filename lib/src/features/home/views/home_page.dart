import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BookBloc _bookBloc;
  late final TextEditingController _searchEC;
  late bool _isSearchBarVisible;

  @override
  void initState() {
    super.initState();
    _searchEC = TextEditingController();
    _isSearchBarVisible = false;
    _bookBloc = context.read<BookBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bookBloc.add(GotAllBooksEvent());
    });
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
      BooksLoadingState() => const CenterCircularProgressIndicator(
          key: Key('BooksLoadingStateWidget'),
        ),
      BookEmptyState() => Center(
          key: const Key('BookEmptyStateWidget'),
          child: InfoItemStateWidget.withNotFoundState(
            message: 'no-books-found-with-terms'.i18n(),
            onPressed: _refreshPage,
          ),
        ),
      BooksLoadedState(:final books) => BooksLoadedStateWidget(
          key: const Key('BooksLoadedStateWidget'),
          books: books,
        ),
      BookErrorSate(errorMessage: final message) => Center(
          key: const Key('BookErrorSateWidget'),
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
    return SafeArea(
      bottom: false,
      child: RefreshIndicator.adaptive(
        onRefresh: () async => _refreshPage(),
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _isSearchBarVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  right: 16.0,
                  left: 16.0,
                ),
                child: AnimatedSearchBar(
                  key: const Key('AnimatedSearchBar'),
                  searchEC: _searchEC,
                  onSubmitted: _onSubmittedSearch,
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<BookBloc, BookState>(
                bloc: _bookBloc,
                listener: (_, state) => setState(() {
                  _isSearchBarVisible = state is BooksLoadedState;
                }),
                builder: _getBookStateWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
