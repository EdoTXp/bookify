import 'package:bookify/src/core/helpers/error_code/rest_client_error_code/rest_client_error_code_extension.dart';
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
    _bookBloc = context.read<BookBloc>()..add(GotAllBooksEvent());
    _searchEC = TextEditingController();
    _isSearchBarVisible = false;
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
      BooksLoadedState(:final books) => RefreshIndicator.adaptive(
        onRefresh: () async => _refreshPage(),
        color: Theme.of(context).colorScheme.secondary,
        child: BooksLoadedStateWidget(
          key: const Key('BooksLoadedStateWidget'),
          books: books,
        ),
      ),
      BookErrorState(
        :final errorCode,
        :final errorDescriptionMessage,
      ) =>
        Center(
          key: const Key('BookErrorStateWidget'),
          child: InfoItemStateWidget.withErrorState(
            message: errorCode.toLocalizedMessage(errorDescriptionMessage),
            onPressed: _refreshPage,
          ),
        ),
    };
  }

  void _onSubmittedSearch(String value, SearchType searchType) {
    if (value.trim().isEmpty) {
      return;
    }

    _bookBloc.add(switch (searchType) {
      SearchType.title => FoundBooksByTitleEvent(title: value),
      SearchType.author => FoundBooksByAuthorEvent(author: value),
      SearchType.category => FoundBooksByCategoryEvent(category: value),
      SearchType.publisher => FoundBooksByPublisherEvent(publisher: value),
      SearchType.isbn => FoundBooksByIsbnEvent(isbn: value),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
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
    );
  }
}
