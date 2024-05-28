import 'package:bookify/src/features/readings_timer/bloc/readings_timer_bloc.dart';
import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/features/readings_timer/views/widgets/readings_timer_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingsTimerPage extends StatefulWidget {
  static const routeName = '/readings_timer';

  final ReadingDto readingDto;

  const ReadingsTimerPage({
    super.key,
    required this.readingDto,
  });

  @override
  State<ReadingsTimerPage> createState() => _ReadingsTimerPageState();
}

class _ReadingsTimerPageState extends State<ReadingsTimerPage> {
  late final ReadingsTimerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ReadingsTimerBloc>()
      ..add(
        GotReadingsUserTimerEvent(),
      );
  }

  Widget _getWidgetOnReadingsTimerState(
    BuildContext context,
    ReadingsTimerState state,
  ) {
    return switch (state) {
      ReadingsTimerLoadingState() => const CenterCircularProgressIndicator(),
      ReadingsTimerEmptyState() ||
      ReadingsTimerLoadedState() =>
        ReadingsTimerWidget(
          readingDto: widget.readingDto,
          timerDurationInSeconds: state is ReadingsTimerLoadedState
              ? state.initialUserTimerInSeconds
              : 300,
        ),
      ReadingsTimerErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _onRefreshPage,
        ),
    };
  }

  void _onRefreshPage() {
    _bloc.add(GotReadingsUserTimerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReadingsTimerBloc, ReadingsTimerState>(
        bloc: _bloc,
        builder: _getWidgetOnReadingsTimerState,
      ),
    );
  }
}
