import 'package:bookify/src/features/bookcase/views/bookcase/bloc/bookcase_bloc.dart';
import 'package:bookify/src/features/bookcase/views/bookcase/views/widgets/bookcase_states_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookcasePage extends StatefulWidget {
  const BookcasePage({super.key});

  @override
  State<BookcasePage> createState() => _BookcasePageState();
}

class _BookcasePageState extends State<BookcasePage> {
  late BookcaseBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookcaseBloc>();
    _bloc.add(GotAllBookcasesEvent());
  }

  Widget _getWidgetOnState(BuildContext context, BookcaseState state) {
    return switch (state) {
      BookcaseLoadingState() =>
        const Center(child: CircularProgressIndicator()),
      BookcaseEmptyState() => BookcaseEmptyStateWidget(onTap: () {}),
      BookcaseLoadedState(bookcasesDto: final bookcasesDto) =>
        BookcaseLoadedStateWidget(bookcasesDto: bookcasesDto),
      BookcaseErrorState(errorMessage: final message) =>
        BookcaseErrorStateWidget(message: message),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookcaseBloc, BookcaseState>(
      bloc: _bloc,
      builder: _getWidgetOnState,
    );
  }
}
