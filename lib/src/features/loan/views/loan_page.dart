import 'package:bookify/src/features/loan/bloc/loan_bloc.dart';
import 'package:bookify/src/features/loan/widgets/loan_loaded_state_widget/loan_loaded_state_widget.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/item_empty_state_widget/item_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

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
        FoundLoanByBookTitleEvent(
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
      LoanLoadingState() => const CenterCircularProgressIndicator(),
      LoanEmptyState() => Center(
          child: ItemEmptyStateWidget(
            key: const Key('Loan Empty State'),
            label: 'create-new-loan-button'.i18n(),
            onTap: () async {
              final loanInserted = await Navigator.pushNamed(
                context,
                LoanInsertionPage.routeName,
              ) as bool?;

              if (loanInserted != null && loanInserted) {
                _refreshPage();
              }
            },
          ),
        ),
      LoanLoadedState(:final loansDto) => LoanLoadedStateWidget(
          key: const Key('Loan Loaded State'),
          loansDto: loansDto,
          refreshPage: _refreshPage,
        ),
      LoanNotFoundState() => InfoItemStateWidget.withNotFoundState(
          message: 'no-loans-found-with-terms'.i18n(),
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
