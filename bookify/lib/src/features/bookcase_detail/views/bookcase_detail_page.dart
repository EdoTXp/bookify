import 'package:bookify/src/features/bookcase_detail/bloc/bookcase_detail_bloc.dart';
import 'package:bookify/src/features/bookcase_detail/widgets/widgets.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookcaseDetailPage extends StatefulWidget {
  final BookcaseModel bookcaseModel;

  const BookcaseDetailPage({
    super.key,
    required this.bookcaseModel,
  });

  @override
  State<BookcaseDetailPage> createState() => _BookcaseDetailPageState();
}

class _BookcaseDetailPageState extends State<BookcaseDetailPage> {
  late BookcaseModel actualBookcase;
  late BookcaseDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BookcaseDetailBloc>();

    actualBookcase = widget.bookcaseModel;

    _refreshPage();
  }

  Widget _getWidgetOnBookcaseDetailState(
    BuildContext context,
    BookcaseDetailState state,
  ) {
    return switch (state) {
      BookcaseDetailLoadingState() =>
        const Center(child: CircularProgressIndicator()),
      BookcaseDetailEmptyState() => BookcaseDetailEmptyStateWidget(
          bookcase: actualBookcase,
          onTap: () {},
        ),
      BookcaseDetailLoadedState(:final books) =>
        BookcaseDetailLoadedStateWidget(
          books: books,
        ),
      BookcaseDetailErrorState(:final errorMessage) =>
        BookcaseDetailErrorStateWidget(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(GotBookcaseBooksEvent(bookcaseId: actualBookcase.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookcaseDetailBloc, BookcaseDetailState>(
      bloc: _bloc,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) async {
                if (value == 'Editar Estante') {
                  final BookcaseModel? bookcaseUpdated;

                  bookcaseUpdated = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookcaseInsertionPage(
                        bookcaseModel: actualBookcase,
                      ),
                    ),
                  );

                  if (bookcaseUpdated != null) {
                    setState(() {
                      actualBookcase = bookcaseUpdated!;
                    });
                  }
                }
              },
              itemBuilder: (context) {
                return {
                  'Editar Estante',
                  'Apagar Estante',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: _getWidgetOnBookcaseDetailState(
          context,
          state,
        ),
      ),
    );
  }
}
