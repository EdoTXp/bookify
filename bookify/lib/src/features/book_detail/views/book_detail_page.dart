import 'package:bookify/src/features/book_detail/bloc/book_detail_bloc.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/app_services/launch_url_service/launch_url_service.dart';
import 'package:bookify/src/shared/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/features/book_detail/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page where it shows the details of a book.
class BookDetailPage extends StatefulWidget {
  final BookModel book;

  /// Required parameters BookModel book
  const BookDetailPage({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  /// Used for expand the book detail.
  bool _isEllipsisText = true;

  /// Show the title on appbar when [_isScrollWhenTitleVisible] is false
  bool _isScrollWhenTitleVisible = true;

  /// Change the [ElevatedButton] and bookmark [Icon]
  /// based on whether the book has been saved on database.
  bool _bookIsInserted = false;

  /// Used to avoid multiple clicks on the [ElevatedButton].
  bool _canClickToAddOrRemove = false;

  /// Disable the snackbar when initState
  late bool _isInitState;

  /// [Bloc] of [BookDetailPage]
  late BookDetailBloc bloc;

  /// Controller to verify the position of the scroll.
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_setAppBarTitleIsVisible);

    bloc = context.read<BookDetailBloc>();
    bloc.add(VerifiedBookIsInsertedEvent(bookId: widget.book.id));

    // Enabled for disable the snackbar
    _isInitState = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setAppBarTitleIsVisible() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    //Scroll under the book title in pixels depending on the book description is ellipsed.
    double underTitleBookScroll =
        (_isEllipsisText) ? maxScroll * .8 : maxScroll * .15;

    bool isTitleVisible = (currentScroll <= underTitleBookScroll);

    setState(() => _isScrollWhenTitleVisible = (isTitleVisible) ? true : false);
  }

  void _handleBookDetailsState(context, state) {
    switch (state) {
      case BookDetailLoadingState():
        _canClickToAddOrRemove = false;

        SnackbarService.showSnackBar(
          context,
          'Carregando o livro...',
          SnackBarType.info,
        );
        break;

      case BookDetailLoadedState():
        _bookIsInserted = state.bookIsInserted;
        _canClickToAddOrRemove = true;

        if (!_isInitState) {
          final message = (_bookIsInserted)
              ? 'Livro inserido com sucesso'
              : 'Livro removido com sucesso';

          SnackbarService.showSnackBar(
            context,
            message,
            SnackBarType.success,
          );
        }

        // disabled for show the snackbar
        _isInitState = false;
        break;

      case BookDetailErrorState(errorMessage: final message):
        SnackbarService.showSnackBar(
          context,
          message,
          SnackBarType.error,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final authors =
        book.authors.map((author) => author.name).toList().join(', ');
    final categories =
        book.categories.map((category) => category.name).toList().join(', ');

    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<BookDetailBloc, BookDetailState>(
      listener: _handleBookDetailsState,
      bloc: bloc,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Visibility(
              visible: !_isScrollWhenTitleVisible,
              child: Center(
                child: Text(
                  book.title,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  (_bookIsInserted) ? Icons.bookmark : Icons.bookmark_border,
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 8.0,
              bottom: 16.0,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${book.title} ― $authors',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: BookWidget(
                      height: 300,
                      width: 200,
                      bookImageUrl: book.imageUrl,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${book.pageCount} PÁGINAS',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '9H PARA LER',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BookifyOutlinedButton(
                          text: 'Ir para loja',
                          suffixIcon: Icons.store,
                          onPressed: () async =>
                              LaunchUrlService.launchUrl(book.buyLink),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BookifyElevatedButton(
                          suffixIcon:
                              (_bookIsInserted) ? Icons.remove : Icons.add,
                          text: (_bookIsInserted) ? 'Remover' : 'Adicionar',
                          onPressed: () {
                            if (_canClickToAddOrRemove) {
                              bloc.add(
                                (_bookIsInserted)
                                    ? BookRemovedEvent(bookId: book.id)
                                    : BookInsertedEvent(bookModel: book),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () =>
                        setState(() => _isEllipsisText = !_isEllipsisText),
                    child: Text(
                      widget.book.description,
                      maxLines: (_isEllipsisText) ? 4 : null,
                      textAlign: TextAlign.justify,
                      overflow: (_isEllipsisText)
                          ? TextOverflow.ellipsis
                          : TextOverflow.visible,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Avaliações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BookRating(
                            averageRating: book.averageRating,
                            ratingsCount: book.ratingsCount,
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informações do Livro',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            BookDescriptionWidget(
                                title: 'Editora: ', content: book.publisher),
                            BookDescriptionWidget(
                                title: 'Gêneros: ', content: categories),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
