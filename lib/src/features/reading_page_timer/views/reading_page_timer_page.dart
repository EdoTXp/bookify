import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/features/reading_page_timer/bloc/reading_page_timer_bloc.dart';
import 'widgets/reading_page_timer_loaded_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ReadingPageTimerPage extends StatefulWidget {
  /// The Route Name = '/reading_page_timer'
  static const routeName = '/reading_page_timer';

  const ReadingPageTimerPage({super.key});

  @override
  State<ReadingPageTimerPage> createState() => _ReadingPageTimerPageState();
}

class _ReadingPageTimerPageState extends State<ReadingPageTimerPage> {
  late final ReadingPageTimerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ReadingPageTimerBloc>();
  }

  void _handleReadingPageTimerStateListener(
    BuildContext context,
    ReadingPageTimerState state,
  ) {
    switch (state) {
      case ReadingPageTimerLoadingState():
        SnackbarService.showSnackBar(
          context,
          'wait-snackbar'.i18n(),
          SnackBarType.info,
        );
        break;
      case ReadingPageTimerInsertedState():
        SnackbarService.showSnackBar(
          context,
          'reading-time-success-snackbar'.i18n(),
          SnackBarType.success,
        );

        Future.delayed(
          const Duration(seconds: 2),
        ).then(
          Navigator.of(context).pop,
        );
        break;
      case ReadingPageTimerErrorState(:final errorMessage):
        SnackbarService.showSnackBar(
          context,
          errorMessage,
          SnackBarType.error,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ReadingPageTimerBloc, ReadingPageTimerState>(
          bloc: _bloc,
          listener: _handleReadingPageTimerStateListener,
          child: ReadingPageTimerLoadedStateWidget(
            onFinish: (seconds) {
              _bloc.add(
                InsertedReadingPageTimeEvent(
                  readingPageTime: seconds,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
