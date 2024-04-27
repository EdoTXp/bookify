import 'package:bookify/src/features/book_detail/views/book_detail_page.dart';
import 'package:bookify/src/features/book_on_bookcase_detail/bloc/book_on_bookcase_detail_bloc.dart';
import 'package:bookify/src/features/book_on_bookcase_detail/views/widgets/widgets.dart';
import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/shared/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/book_with_detail_widget/book_with_detail_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookOnBookcaseDetailPage extends StatefulWidget {
  /// The Route Name = '/bookcase_detail'
  static const routeName = '/bookcase_on_bookcase_detail';

  final BookModel bookModel;
  final int bookcaseId;

  const BookOnBookcaseDetailPage({
    super.key,
    required this.bookModel,
    required this.bookcaseId,
  });

  @override
  State<BookOnBookcaseDetailPage> createState() =>
      _BookOnBookcaseDetailPageState();
}

class _BookOnBookcaseDetailPageState extends State<BookOnBookcaseDetailPage> {
  late final BookOnBookcaseDetailBloc _bloc;
  late bool _canPopPage;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookOnBookcaseDetailBloc>()
      ..add(
        GotCountOfBookcasesByBookEvent(
          bookId: widget.bookModel.id,
        ),
      );
    _canPopPage = true;
  }

  Future<void> _handleBookOnBookcaseDetailsStateListener(
    BuildContext context,
    BookOnBookcaseDetailState state,
  ) async {
    if (state is BookOnBookcaseDetailDeletedState) {
      setState(() {
        _canPopPage = false;
      });

      SnackbarService.showSnackBar(
        context,
        'livro removido da estante com sucesso.\nAguarde até voltar à página anterior',
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2))
          .then((_) => Navigator.of(context).pop());
    } else if (state is BookOnBookcaseDetailErrorState) {
      setState(() {
        _canPopPage = false;
      });

      final errorMessage = state.errorMessage;

      SnackbarService.showSnackBar(
        context,
        'Erro $errorMessage',
        SnackBarType.error,
      );

      await Future.delayed(const Duration(seconds: 2))
          .then((_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.bookModel;

    return PopScope(
      canPop: _canPopPage,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            book.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        body: BlocConsumer<BookOnBookcaseDetailBloc, BookOnBookcaseDetailState>(
          bloc: _bloc,
          listener: _handleBookOnBookcaseDetailsStateListener,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BookWithDetailWidget(
                      bookImageUrl: book.imageUrl,
                      bookDescription: book.description,
                      bookAverageRating: book.averageRating,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        switch (state) {
                          BookOnBookcaseDetailLoadingState() ||
                          BookOnBookcaseDetailDeletedState() =>
                            const SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          BookOnBookcaseDetailLoadedState(
                            :final bookcasesCount
                          ) =>
                            BookcasesCountWidget(
                              message: bookcasesCount.toString(),
                              statusType: StatusType.loaded,
                            ),
                          BookOnBookcaseDetailErrorState() =>
                            const BookcasesCountWidget(
                              message: 'Acounteceu um erro.',
                              statusType: StatusType.error,
                            ),
                        },
                        const SizedBox(
                          width: 10,
                        ),
                        BookStateWidget(
                          bookStatus: book.status!,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    BookifyOutlinedButton.expanded(
                      text: 'Ir para os detalhes',
                      suffixIcon: Icons.description,
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          BookDetailPage.routeName,
                          arguments: book,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BookifyElevatedButton.expanded(
                      text: 'Remover livro da estante',
                      suffixIcon: BookifyIcons.bookcase,
                      onPressed: () async {
                        String complementMessage = '';

                        if (book.status == BookStatus.loaned ||
                            book.status == BookStatus.reading) {
                          complementMessage =
                              'Lembrando que o livro está ${book.status} e não será removido dessa categoria.';
                        }

                        await ShowDialogService.showAlertDialog(
                          context: context,
                          title: 'Remover o livro da estante',
                          content:
                              'Clicando em CONFIRMAR, removerá esse livro da estante.\n$complementMessage\nTem Certeza?',
                          confirmButtonFunction: () {
                            _bloc.add(
                              DeletedBookOnBookcaseEvent(
                                bookId: book.id,
                                bookcaseId: widget.bookcaseId,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
