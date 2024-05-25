import 'package:bookify/src/features/book_detail/views/widgets/book_pages_reading_time/bloc/book_pages_reading_time_bloc.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPagesReadingTime extends StatefulWidget {
  final int pagesCount;

  const BookPagesReadingTime({
    super.key,
    required this.pagesCount,
  });

  @override
  State<BookPagesReadingTime> createState() => _BookPagesReadingTimeState();
}

class _BookPagesReadingTimeState extends State<BookPagesReadingTime> {
  late final BookPagesReadingTimeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookPagesReadingTimeBloc>()
      ..add(
        GotBookPagesReadingTimeEvent(),
      );
  }

  Widget _getWidgetOnBookPagesReadingTimeState(
    BuildContext context,
    BookPagesReadingTimeState state,
  ) {
    return switch (state) {
      BookPagesReadingTimeLoadingState() =>
        const CenterCircularProgressIndicator(),
      BookPagesReadingTimeLoadedState(:final userPageReadingTime) => Text(
          '${userPageReadingTime.readingTimeForTotalBookPage(widget.pagesCount)}H PARA LER',
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 14,
          ),
        ),
      BookPagesReadingTimeErrorState(:final errorMessage) => Text(
          errorMessage,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 14,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookPagesReadingTimeBloc, BookPagesReadingTimeState>(
      bloc: _bloc,
      builder: _getWidgetOnBookPagesReadingTimeState,
    );
  }
}
