import 'package:bookify/src/features/readings_detail/bloc/readings_detail_bloc.dart';
import 'package:bookify/src/features/readings_timer/views/readings_timer.page.dart';
import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/core/helpers/date_time_format/date_time_format_extension.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/buttons/buttons.dart';
import 'package:bookify/src/shared/widgets/book_with_detail_widget/book_with_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ReadingsDetailPage extends StatefulWidget {
  /// The Route Name = '/readings_detail'
  static const routeName = '/readings_detail';

  final ReadingDto readingDto;

  const ReadingsDetailPage({
    super.key,
    required this.readingDto,
  });

  @override
  State<ReadingsDetailPage> createState() => _ReadingsDetailPageState();
}

class _ReadingsDetailPageState extends State<ReadingsDetailPage> {
  late final ReadingsDetailBloc _bloc;
  late bool _canPopPage;
  late double _readedPages;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<ReadingsDetailBloc>();
    _canPopPage = true;
    _readedPages = widget.readingDto.reading.pagesReaded.toDouble();
  }

  Future<void> _handleReadingDetailState(
    BuildContext context,
    ReadingsDetailState state,
  ) async {
    switch (state) {
      case ReadingsDetailLoadingState():
        SnackbarService.showSnackBar(
          context,
          'wait-snackbar'.i18n(),
          SnackBarType.info,
        );
        break;

      case ReadingsDetailUpdatedState():
        SnackbarService.showSnackBar(
          context,
          'reading-successfully-updated-snackbar'.i18n(),
          SnackBarType.success,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        );
        break;

      case ReadingsDetailFinishedState():
        SnackbarService.showSnackBar(
          context,
          'reading-successfully-finished-snackbar'.i18n(),
          SnackBarType.success,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        );
        break;

      case ReadingsDetailErrorState(:final errorMessage):
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

  Future<void> _updateReadingOnPressedButton() async {
    final bookPages = widget.readingDto.book.pageCount;

    final contentMessage = (_readedPages == bookPages)
        ? 'finish-reading-message'.i18n()
        : 'update-reading-message'.i18n([
            _readedPages.round().toString(),
          ]);

    final updatedReading = widget.readingDto.reading.copyWith(
      pagesReaded: _readedPages.round(),
      lastReadingDate: DateTime.now(),
    );

    await ShowDialogService.showAlertDialog(
      context: context,
      title: (_readedPages == bookPages)
          ? 'finish-reading-title'.i18n()
          : 'update-reading-title'.i18n(),
      content: contentMessage,
      confirmButtonFunction: () {
        setState(() {
          _canPopPage = false;
        });

        _bloc.add(
          (_readedPages == bookPages)
              ? FinishedReadingsEvent(
                  readingId: widget.readingDto.reading.id!,
                  bookId: widget.readingDto.book.id,
                )
              : UpdatedReadingsEvent(readingModel: updatedReading),
        );
        Navigator.of(context).pop();
      },
      cancelButtonFunction: () {
        setState(() {
          _readedPages = widget.readingDto.reading.pagesReaded.toDouble();
        });
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.readingDto.book;
    final reading = widget.readingDto.reading;

    return PopScope(
      canPop: _canPopPage,
      child: BlocConsumer<ReadingsDetailBloc, ReadingsDetailState>(
        bloc: _bloc,
        listener: _handleReadingDetailState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${book.title} - ${book.authors.first.name}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BookWithDetailWidget(
                      bookImageUrl: book.imageUrl,
                      bookDescription: book.description,
                      bookAverageRating: book.averageRating,
                    ),
                    if (reading.lastReadingDate != null) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'last-reading-time-at-title'.i18n(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: reading.lastReadingDate!.toFormattedDate(
                                'dd/MM/yyyy - HH:mm',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'pages-read-title'.i18n(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: _readedPages.round().toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Slider.adaptive(
                      key: const Key('Reading Slider'),
                      min: 0.0,
                      max: book.pageCount.toDouble(),
                      value: _readedPages,
                      label: _readedPages.round().toString(),
                      divisions: book.pageCount,
                      onChanged: (value) {
                        setState(() {
                          _readedPages = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BookifyOutlinedButton.expanded(
                      key: const Key('Continue Reading Button'),
                      text: 'continue-reading-button'.i18n(),
                      suffixIcon: Icons.menu_book_rounded,
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(
                          ReadingsTimerPage.routeName,
                          arguments: widget.readingDto,
                        );

                        if (context.mounted) {
                          await ShowDialogService.showSimpleDialog(
                            context: context,
                            title: 'update-slider-message'.i18n(),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BookifyElevatedButton.expanded(
                      key: const Key('Update / Finish Reading Button'),
                      text: (_readedPages == book.pageCount)
                          ? 'finish-reading-button'.i18n()
                          : 'update-reading-button'.i18n(),
                      suffixIcon: Icons.check_circle_outline_outlined,
                      onPressed: () async {
                        if (_readedPages.toInt() != reading.pagesReaded) {
                          await _updateReadingOnPressedButton();
                        }
                      },
                    )
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
