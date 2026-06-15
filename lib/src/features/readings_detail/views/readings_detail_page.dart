import 'dart:async';
import 'package:bookify/src/core/helpers/error_code/local_database_error_code/local_database_error_code_extension.dart';
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

/// Represents the detail page for a specific reading session.
///
/// Displays book information, current progress, and allows the user
/// to update their read pages or finish the book.
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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ReadingsDetailBloc>();
    _canPopPage = true;
    _readedPages = widget.readingDto.reading.pagesReaded.toDouble();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Listens to the [ReadingsDetailBloc] state changes and shows the appropriate feedback UI.
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

      case ReadingsDetailErrorState(
        :final errorCode,
        :final errorDescriptionMessage,
      ):
        SnackbarService.showSnackBar(
          context,
          errorCode.toLocalizedMessage(errorDescriptionMessage),
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

  /// Schedules an automatic update of the reading progress.
  ///
  /// Uses a [Timer] to wait 500 milliseconds after the last interaction before
  /// dispatching the [UpdatedReadingsEvent]. If the user finishes the book,
  /// the update is skipped to force the user to use the "Finish" button.
  void _scheduleReadingUpdate(double value) {
    final bookPages = widget.readingDto.book.pageCount;

    // Cancel any active timer if the user interacts again quickly.
    _debounceTimer?.cancel();

    // Only auto-update if it's not the final page and the value actually changed.
    if (value.toInt() < bookPages &&
        value.toInt() != widget.readingDto.reading.pagesReaded) {
      _debounceTimer = Timer(const Duration(milliseconds: 400), () {
        final updatedReading = widget.readingDto.reading.copyWith(
          pagesReaded: value.round(),
          lastReadingDate: DateTime.now(),
        );

        _bloc.add(
          UpdatedReadingsEvent(
            readingModel: updatedReading,
          ),
        );
      });
    }
  }

  /// Increases the read pages by one.
  ///
  /// Instantly updates the UI and schedules a database update.
  void _incrementPage() {
    final bookPages = widget.readingDto.book.pageCount.toDouble();
    if (_readedPages < bookPages) {
      setState(() {
        _readedPages++;
      });
      _scheduleReadingUpdate(_readedPages);
    }
  }

  /// Decreases the read pages by one.
  ///
  /// Instantly updates the UI and schedules a database update.
  void _decrementPage() {
    if (_readedPages > 0) {
      setState(() {
        _readedPages--;
      });
      _scheduleReadingUpdate(_readedPages);
    }
  }

  /// Strictly handles the explicit action of completing the book.
  ///
  /// Shows a confirmation dialog and prevents popping the view until
  /// the transaction is confirmed.
  Future<void> _finishReadingOnPressedButton() async {
    await ShowDialogService.showAlertDialog(
      context: context,
      title: 'finish-reading-title'.i18n(),
      content: 'finish-reading-message'.i18n(),
      confirmButtonFunction: () {
        // Lock navigation to prevent data corruption while finishing.
        setState(() {
          _canPopPage = false;
        });

        _bloc.add(
          FinishedReadingsEvent(
            readingId: widget.readingDto.reading.id!,
            bookId: widget.readingDto.book.id,
          ),
        );

        Navigator.of(context).pop();
      },
      cancelButtonFunction: () {
        // Revert slider to the last saved state if the user aborts.
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
    final isBookFinished = _readedPages.toInt() == book.pageCount;
    final colorScheme = Theme.of(context).colorScheme;

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
                            ),
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
                    Row(
                      children: [
                        // Decrement Button
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: _readedPages > 0 ? _decrementPage : null,
                          tooltip: 'decrement-page-tooltip'.i18n(),
                        ),
                        Expanded(
                          child: Slider.adaptive(
                            key: const Key('ReadingSlider'),
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
                            onChangeEnd: _scheduleReadingUpdate,
                          ),
                        ),
                        // Increment Button
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_outlined,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                          onPressed: _readedPages < book.pageCount
                              ? _incrementPage
                              : null,
                          tooltip: 'increment-page-tooltip'.i18n(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BookifyOutlinedButton.expanded(
                      key: const Key('ContinueReadingButton'),
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
                    // The finish button only appears when the user reaches the end
                    if (isBookFinished)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'finish-reading-hint'.i18n(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          BookifyElevatedButton.expanded(
                            key: const Key('FinishReadingButton'),
                            text: 'finish-reading-button'.i18n(),
                            suffixIcon: Icons.check_circle_outline_outlined,
                            onPressed: _finishReadingOnPressedButton,
                          ),
                        ],
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
