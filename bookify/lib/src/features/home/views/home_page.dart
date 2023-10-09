import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/home/widgets/animated_search_bar/animated_search_bar.dart';
import 'package:bookify/src/features/home/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  late BookBloc bookBloc;

  final searchEC = TextEditingController();
  bool searchBarIsVisible = true;

  @override
  void initState() {
    super.initState();
    bookBloc = context.read<BookBloc>();
    bookBloc.add(GotAllBooksEvent());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    bookBloc.close();
    searchEC.dispose();
    super.dispose();
  }

  void _refreshPage() {
    bookBloc.add(GotAllBooksEvent());
    searchEC.clear();
  }

  Widget _getBookStateWidget(BuildContext context, BookState state) {
    return switch (state) {
      BooksLoadingState() => const Center(child: CircularProgressIndicator()),
      BookEmptyState() =>
        BookErrorSateWidget.bookEmptyState(onPressed: _refreshPage),
      BooksLoadedState(:final books) => BooksLoadedStateWidget(books: books),
      BookErrorSate(:final message) =>
        BookErrorSateWidget(stateMessage: message, onPressed: _refreshPage),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async => _refreshPage(),
      color: Theme.of(context).colorScheme.secondary,
      child: BlocConsumer<BookBloc, BookState>(
        bloc: bookBloc,
        listener: (_, state) =>
            searchBarIsVisible = state is BooksLoadedState ? false : true,
        builder: (BuildContext context, state) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: Offstage(
                  offstage: searchBarIsVisible,
                  child: AnimatedSearchBar(
                    searchEC: searchEC,
                    onSubmitted: (value, searchType) {
                      if (value.isNotEmpty) {
                        switch (searchType) {
                          case SearchType.title:
                            bookBloc.add(FindedBooksByTitleEvent(title: value));
                            break;
                          case SearchType.author:
                            bookBloc
                                .add(FindedBooksByAuthorEvent(author: value));
                            break;
                          case SearchType.category:
                            bookBloc.add(
                                FindedBooksByCategoryEvent(category: value));
                            break;
                          case SearchType.publisher:
                            bookBloc.add(
                                FindedBooksByPublisherEvent(publisher: value));
                            break;
                          case SearchType.isbn:
                            bookBloc.add(FindedBooksByIsbnEvent(isbn: value));
                            break;
                        }
                      }
                    },
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
