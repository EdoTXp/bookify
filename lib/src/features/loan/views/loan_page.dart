import 'package:bookify/src/features/loan/bloc/loan_bloc.dart';
import 'package:bookify/src/features/loan/widgets/loan_loaded_state_widget/loan_loaded_state_widget.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanPage extends StatefulWidget {
  final String? searchQuery;

  const LoanPage({
    super.key,
    this.searchQuery,
  });

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  late final LoanBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<LoanBloc>()..add(GotAllLoansEvent());
  }

  @override
  void didUpdateWidget(covariant LoanPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final actualSearchQuery = widget.searchQuery;
    final oldSearchQuery = oldWidget.searchQuery;

    if (actualSearchQuery == null && oldSearchQuery != null) {
      _refreshPage();
      return;
    }

    if (actualSearchQuery != null) {
      _bloc.add(
        FindedLoanByBookNameEvent(
          searchQueryName: actualSearchQuery,
        ),
      );
    }
  }

  void _refreshPage() {
    _bloc.add(GotAllLoansEvent());
  }

  Widget _getWidgetOnLoanState(BuildContext context, LoanState state) {
    return switch (state) {
      LoanLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      LoanLoadedState(:final loansDto) => LoanLoadedStateWidget(
          loansDto: loansDto,
          refreshPage: _refreshPage,
        ),
      LoanEmptyState() => ItemEmptyStateWidget(
          label: 'Criar um novo empréstimo de um livro',
          onTap: () async {
            await Navigator.pushNamed(
              context,
              LoanInsertionPage.routeName,
            );
            _refreshPage();
          },
        ),
      LoanNotFoundState() => InfoItemStateWidget.withNotFoundState(
          message:
              'Nenhuma Empréstimo encontrado com esses termos.\nVerifique se foi digitado o título do livro corretamente.',
          onPressed: _refreshPage,
        ),
      LoanErrorState(:final errorMessage) => Center(
          child: InfoItemStateWidget.withErrorState(
            message: errorMessage,
            onPressed: _refreshPage,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanBloc, LoanState>(
      bloc: _bloc,
      builder: _getWidgetOnLoanState,
    );
  }
}
