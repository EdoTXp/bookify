import 'package:bookify/src/features/books_picker/views/widgets/bookcase_picker/bloc/bookcase_picker_bloc.dart';
import 'package:bookify/src/features/books_picker/views/widgets/bookcase_picker/views/widgets/bookcase_picker_loaded_state_widget/bookcase_picker_loaded_state_widget.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class BookcasePickerWidget extends StatefulWidget {
  final void Function(BookModel bookModel) onSelectBookModel;

  const BookcasePickerWidget({
    super.key,
    required this.onSelectBookModel,
  });

  @override
  State<BookcasePickerWidget> createState() => _BookcasePickerWidgetState();
}

class _BookcasePickerWidgetState extends State<BookcasePickerWidget> {
  late final BookcasePickerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookcasePickerBloc>()
      ..add(GotAllBookcasesPickerEvent());
  }

  void _refreshPage() {
    _bloc.add(GotAllBookcasesPickerEvent());
  }

  Widget _getWidgetOnBookcasePickerState(
      BuildContext context, BookcasePickerState state) {
    return switch (state) {
      BookcasePickerLoadingState() => const CenterCircularProgressIndicator(),
      BookcasePickerEmptyState() => Center(
          child: Text(
            'no-bookcases-to-add-message'.i18n(),
            textAlign: TextAlign.center,
          ),
        ),
      BookcasePickerLoadedState(:final bookcasesDto) =>
        BookcasePickerLoadedStateWidget(
          bookcasesDto: bookcasesDto,
          onSelectBookModel: widget.onSelectBookModel,
        ),
      BookcasePickerErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookcasePickerBloc, BookcasePickerState>(
      bloc: _bloc,
      builder: _getWidgetOnBookcasePickerState,
    );
  }
}
