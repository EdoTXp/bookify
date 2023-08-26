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
  late BookBloc bloc;
  bool searchBoxVisible = false;

  @override
  void initState() {
    super.initState();
    bloc = context.read<BookBloc>();
    bloc.add(GotAllBooksEvent());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  Widget getBookStateWidget(BuildContext context, BookState state) {
    switch (state) {
      case BooksLoadingState():
        searchBoxVisible = true;

        return Center(
          child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor),
        );

      case BookEmptyState():
        searchBoxVisible = true;

        return const Center(
          child: Text('Não foi encontrado nenhum livros com esses termos.'),
        );

      case SingleBookLoadedState(:final book):
        searchBoxVisible = false;
        return SingleBookLoadedStateWidget(book: book);

      case BooksLoadedState(:final books):
        searchBoxVisible = false;

        return BooksLoadedStateWidget(books: books);

      case BookErrorSate(:final message):
        searchBoxVisible = true;

        return BookErrorSateWidget(
          stateMessage: message,
          onPressed: () => bloc.add(
            GotAllBooksEvent(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async => bloc.add(GotAllBooksEvent()),
      color: Theme.of(context).primaryColor,
      child: BlocBuilder<BookBloc, BookState>(
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
