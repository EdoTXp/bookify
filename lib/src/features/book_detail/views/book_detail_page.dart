import 'package:bookify/src/features/book_detail/bloc/book_detail_bloc.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/app_services/launcher_service/launcher_service.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/features/book_detail/views/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class BookDetailPage extends StatefulWidget {
  /// The Route Name = '/book_detail'
  static const routeName = '/book_detail';
  final BookModel bookModel;

  const BookDetailPage({
    super.key,
    required this.bookModel,
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
  bool _canClickToInsertOrRemoveButton = false;

  /// [Bloc] of [BookDetailPage]
  late final BookDetailBloc _bloc;

  /// Disable the snackbar when the [VerifiedBookIsInsertedEvent] event is called.
  late bool _isCallVerifyBookEvent;

  /// Controller to verify the position of the scroll.
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_setAppBarTitleIsVisible);

    _bloc = context.read<BookDetailBloc>()
      ..add(VerifiedBookIsInsertedEvent(bookId: widget.bookModel.id));

    // disable the snackbar.
    _isCallVerifyBookEvent = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Show the title of the book on [AppBar] when the scroll under the [Text] Widget of the book.
  void _setAppBarTitleIsVisible() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    //Scroll under the book title in pixels depending on the book description is ellipsed.
    double underTitleBookScroll =
        (_isEllipsisText) ? maxScroll * .8 : maxScroll * .15;

    bool isTitleVisible = (currentScroll <= underTitleBookScroll);

    setState(
      () => _isScrollWhenTitleVisible = (isTitleVisible) ? true : false,
    );
  }

  void _handleBookDetailsStateListener(
    BuildContext context,
    BookDetailState state,
  ) {
    switch (state) {
      case BookDetailLoadingState():
        // Avoid the click on ElevatedButton.
        _canClickToInsertOrRemoveButton = false;
        break;

      case BookDetailLoadedState():
        // Update bookmark icon and text of the ElevatedButton state.
        _bookIsInserted = state.bookIsInserted;

        // enable the click on ElevatedButton.
        _canClickToInsertOrRemoveButton = true;

        if (!_isCallVerifyBookEvent) {
          final message = (_bookIsInserted)
              ? 'book-successfully-added-snackbar'.i18n()
              : 'book-successfully-removed-snackbar'.i18n();

          SnackbarService.showSnackBar(
            context,
            message,
            SnackBarType.success,
          );
        }

        // now can show the snackbar.
        _isCallVerifyBookEvent = false;
        break;

      case BookDetailErrorState(errorMessage: final message):
        // enable the click on ElevatedButton.
        _canClickToInsertOrRemoveButton = true;

        SnackbarService.showSnackBar(
          context,
          message,
          SnackBarType.error,
        );
        break;
    }
  }

  void _insertOrRemoveBook(BookModel book) async {
    if (_bookIsInserted) {
      await ShowDialogService.showAlertDialog(
        context: context,
        title: 'remove-book-title'.i18n([book.title]),
        content: 'remove-book-description'.i18n(),
        confirmButtonFunction: () {
          _bloc.add(BookRemovedEvent(bookId: book.id));
          Navigator.of(context).pop();
        },
      );
    } else {
      _bloc.add(BookInsertedEvent(bookModel: book));
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.bookModel;
    final authors =
        book.authors.map((author) => author.name).toList().join(', ');
    final categories =
        book.categories.map((category) => category.name).toList().join(', ');

    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<BookDetailBloc, BookDetailState>(
      listener: _handleBookDetailsStateListener,
      bloc: _bloc,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Visibility(
              visible: !_isScrollWhenTitleVisible,
              child: Text(
                book.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  // Update bookMark icon
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
                    child: BookWidget.normalSize(
                      bookImageUrl: book.imageUrl,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'pages-label'.i18n([book.pageCount.toString()]),
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 24),
                      BookPagesReadingTime(
                        pagesCount: book.pageCount,
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
                          text: 'go-to-store-button'.i18n(),
                          suffixIcon: Icons.store,
                          onPressed: () async =>
                              await LauncherService.openUrl(book.buyLink),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BookifyElevatedButton(
                          key: const Key('Insert Or Remove Book Button'),
                          // Update the icon
                          suffixIcon:
                              (_bookIsInserted) ? Icons.remove : Icons.add,
                          // Update the text
                          text: (_bookIsInserted)
                              ? 'remove-button'.i18n()
                              : 'add-button'.i18n(),
                          // When is [BookDetailLoadingState] disable the click
                          onPressed: () => (_canClickToInsertOrRemoveButton)
                              ? _insertOrRemoveBook(book)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'synopsis-title'.i18n(),
                    textScaler: TextScaler.noScaling,
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
                      book.description,
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
                          Text(
                            'ratings-title'.i18n(),
                            textScaler: TextScaler.noScaling,
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
                            Text(
                              'book-information-title'.i18n(),
                              textScaler: TextScaler.noScaling,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            BookDescriptionWidget(
                              title: 'publisher-title'.i18n(),
                              content: book.publisher,
                            ),
                            BookDescriptionWidget(
                              title: 'categories-title'.i18n(),
                              content: categories,
                            ),
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
