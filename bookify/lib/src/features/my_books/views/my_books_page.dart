import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/my_books/bloc/my_books_bloc.dart';
import 'package:bookify/src/shared/widgets/list/grid_view/books_grid_view.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MyBooksPage extends StatefulWidget {
  final String? searchQuery;

  const MyBooksPage({
    super.key,
    this.searchQuery,
  });

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  late final MyBooksBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<MyBooksBloc>()..add(GotAllBooksEvent());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyBooksPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final actualSearchQuery = widget.searchQuery;
    final oldSearchQuery = oldWidget.searchQuery;

    if (actualSearchQuery == null && oldSearchQuery != null) {
      _refreshPage();
      return;
    }

    if (actualSearchQuery != null) {
      _bloc.add(
        SearchedBooksEvent(
          searchQuery: actualSearchQuery,
        ),
      );
    }
  }

  Widget _getWidgetOnMyBooksState(BuildContext context, MyBooksState state) {
    return switch (state) {
      MyBooksLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      MyBooksEmptyState() => const Center(
          child: SizedBox(
            child: Text(
              'Não foram encontrados livros salvos. Adicione-os na Página: Início',
            ),
          ),
        ),
      MyBooksLoadedState(:final books) => BooksGridView(
          books: books,
          onTap: (book) async {
            await Navigator.pushNamed(
              context,
              BookDetailPage.routeName,
              arguments: book,
            );
            _refreshPage();
          },
        ),
      MyBooksNotFoundState() => InfoItemStateWidget.withNotFoundState(
          message:
              'Nenhum livro foi encontrado com esses termos.\nVerifique se foi digitada corretamente.',
          onPressed: _refreshPage,
        ),
      MyBooksErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(GotAllBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBooksBloc, MyBooksState>(
      bloc: _bloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is MyBooksLoadedState) ...[
                Text(
                  '${state.books.length} ${(state.books.length == 1) ? 'livro' : 'livros'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
              Expanded(
                child: _getWidgetOnMyBooksState(context, state),
              ),
            ],
          ),
        );
      },
    );
  }
}
