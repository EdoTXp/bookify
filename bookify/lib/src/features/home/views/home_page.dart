import '../../../shared/widgets/textfields/search_box.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../../shared/blocs/book_bloc/book_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  late BookBloc bookBloc;
  bool searchBoxVisible = false;

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
    super.dispose();
  }

  Widget getBookStateWidget(BuildContext context, BookState state) {
    return switch (state) {
      BooksLoadingState() => Center(
          child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor)),
      BookEmptyState() => const Center(
          child: Text('Não foi encontrado nenhum livros com esses termos.')),
      SingleBookLoadedState(:final book) =>
        SingleBookLoadedStateWidget(book: book),
      BooksLoadedState(:final books) => BooksLoadedStateWidget(books: books),
      BookErrorSate(:final message) => BookErrorSateWidget(
          stateMessage: message,
          onPressed: () => bookBloc.add(GotAllBooksEvent()),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async => bookBloc.add(GotAllBooksEvent()),
      color: Theme.of(context).primaryColor,
      child: BlocConsumer<BookBloc, BookState>(
        bloc: bookBloc,
        listener: (_, state) {
          if (state is SingleBookLoadedState || state is BooksLoadedState) {
            searchBoxVisible = true;
          } else {
            searchBoxVisible = false;
          }
        },
        builder: (BuildContext context, state) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: Visibility(
                  visible: searchBoxVisible,
                  child: const SearchBox(),
                ),
              ),
              Expanded(
                child: getBookStateWidget(context, state),
              ),
            ],
          );
        },
      ),
    );
  }
}
