import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/features/reading_page_time_calculator/bloc/reading_page_time_calculator_bloc.dart';
import 'package:bookify/src/features/reading_page_time_calculator/views/widgets/reading_page_timer/reading_page_timer_loaded_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ReadingPageTimerWidget extends StatefulWidget {
  const ReadingPageTimerWidget({super.key});

  @override
  State<ReadingPageTimerWidget> createState() => _ReadingPageTimerWidgetState();
}

class _ReadingPageTimerWidgetState extends State<ReadingPageTimerWidget> {
  late final ReadingPageTimeCalculatorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ReadingPageTimeCalculatorBloc>();
  }

  void _handleReadingPageTimeCalculatorStateListener(
    BuildContext context,
    ReadingPageTimeCalculatorState state,
  ) {
    switch (state) {
      case ReadingPageTimeCalculatorLoadingState():
        SnackbarService.showSnackBar(
          context,
          'wait-snackbar'.i18n(),
          SnackBarType.info,
        );
        break;
      case ReadingPageTimeCalculatorInsertedState():
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
      case ReadingPageTimeCalculatorErrorState(:final errorMessage):
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
    return SafeArea(
      child: BlocListener<ReadingPageTimeCalculatorBloc,
          ReadingPageTimeCalculatorState>(
        bloc: _bloc,
        listener: _handleReadingPageTimeCalculatorStateListener,
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
    );
  }
}
