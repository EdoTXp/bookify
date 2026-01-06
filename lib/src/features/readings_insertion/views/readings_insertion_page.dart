import 'package:bookify/src/features/readings_insertion/bloc/readings_insertion_bloc.dart';
import 'package:bookify/src/core/helpers/textfield_unfocus/textfield_unfocus_extension.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:bookify/src/shared/widgets/book_with_detail_widget/book_with_detail_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:validatorless/validatorless.dart';

class ReadingsInsertionPage extends StatefulWidget {
  /// The Route Name = '/loan_insertion'
  static const routeName = '/readings_insertion';

  final BookModel book;

  const ReadingsInsertionPage({
    super.key,
    required this.book,
  });

  @override
  State<ReadingsInsertionPage> createState() => _ReadingsInsertionPageState();
}

class _ReadingsInsertionPageState extends State<ReadingsInsertionPage> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _pageCountEC;
  late bool _canPopPage;
  late final ReadingsInsertionBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<ReadingsInsertionBloc>();
    _canPopPage = true;

    if (widget.book.pageCount == 0) {
      _formKey = GlobalKey<FormState>();
      _pageCountEC = TextEditingController();
    }
  }

  @override
  void dispose() {
    _formKey?.currentState?.dispose();
    _pageCountEC?.dispose();
    super.dispose();
  }

  Future<void> _handleReadingsInsertionState(
    BuildContext context,
    ReadingsInsertionState state,
  ) async {
    switch (state) {
      case ReadingsInsertionLoadingState():
        SnackbarService.showSnackBar(
          context,
          'wait-snackbar'.i18n(),
          SnackBarType.info,
        );

        break;

      case ReadingsInsertionInsertedState():
        SnackbarService.showSnackBar(
          context,
          'reading-successfully-added-snackbar'.i18n(),
          SnackBarType.success,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
        break;
      case ReadingsInsertionErrorState(:final errorMessage):
        SnackbarService.showSnackBar(
          context,
          errorMessage,
          SnackBarType.error,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: _canPopPage,
      child: BlocConsumer<ReadingsInsertionBloc, ReadingsInsertionState>(
        listener: _handleReadingsInsertionState,
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${book.title} - ${book.authors.first.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    BookWithDetailWidget(
                      bookImageUrl: book.imageUrl,
                      bookDescription: book.description,
                      bookAverageRating: book.averageRating,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      (book.pageCount > 0)
                          ? 'pages-to-read-label'.i18n([
                              book.pageCount.toString(),
                            ])
                          : 'no-pages-count-found'.i18n(),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (book.pageCount == 0) ...[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _pageCountEC,
                          cursorColor: colorScheme.secondary,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required(
                                'this-field-is-required'.i18n(),
                              ),
                              Validatorless.numbersBetweenInterval(
                                1,
                                2000,
                                'enter-pages-between-1-and-2000'.i18n(),
                              )
                            ],
                          ),
                          onTapOutside: (_) => context.unfocus(),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'indicate-number-of-pages-label'.i18n(),
                            hintStyle: TextStyle(
                              color: Colors.grey.withValues(
                                alpha: .75,
                              ),
                            ),
                            label: Text(
                              'pages-title'.i18n(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    BookifyOutlinedButton.expanded(
                      key: const Key('AddReadingButton'),
                      text: 'add-reading-button'.i18n(),
                      suffixIcon: Icons.auto_stories_rounded,
                      onPressed: () {
                        if (_formKey != null &&
                            !(_formKey!.currentState!.validate())) {
                          return;
                        }
                        final pageCount = _pageCountEC?.text;
                        _bloc.add(
                          InsertedReadingsEvent(
                            bookId: book.id,
                            pagesUpdated: (pageCount != null)
                                ? int.parse(pageCount)
                                : null,
                          ),
                        );

                        setState(() {
                          _canPopPage = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
