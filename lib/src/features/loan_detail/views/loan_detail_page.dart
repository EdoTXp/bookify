import 'package:bookify/src/features/loan_detail/bloc/loan_detail_bloc.dart';
import 'package:bookify/src/features/loan_detail/views/widgets/loan_detail_loaded_widget.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class LoanDetailPage extends StatefulWidget {
  /// The Route Name = '/loan_detail'
  static const routeName = '/loan_detail';

  final int loanId;

  const LoanDetailPage({
    super.key,
    required this.loanId,
  });

  @override
  State<LoanDetailPage> createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  bool canPopPage = true;
  late final LoanDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<LoanDetailBloc>();

    _bloc.add(
      GotLoanDetailEvent(
        id: widget.loanId,
      ),
    );
    return;
  }

  Widget _getWidgetOnLoanDetailState(
    BuildContext context,
    LoanDetailState state,
  ) {
    return switch (state) {
      LoanDetailLoadingState() ||
      LoanDetailFinishedState() =>
        const CenterCircularProgressIndicator(),
      LoanDetailLoadedState(:final loanDto) => LoanDetailLoadedWidget(
          key: const Key('Loan Detail LoadedState'),
          loanDto: loanDto,
          onPressedButton: () async {
            await ShowDialogService.showAlertDialog(
              context: context,
              title: 'finish-loan-title'.i18n(),
              content: 'finish-loan-description'.i18n(),
              confirmButtonFunction: () {
                _bloc.add(
                  FinishedLoanDetailEvent(
                    loanId: loanDto.loanModel.id!,
                    bookId: loanDto.loanModel.bookId,
                  ),
                );
                Navigator.of(context).pop();
              },
            );
          },
        ),
      LoanDetailErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(
      GotLoanDetailEvent(
        id: widget.loanId,
      ),
    );
  }

  Future<void> _handleLoanDetailsStateListener(
    BuildContext context,
    LoanDetailState state,
  ) async {
    if (state is LoanDetailFinishedState) {
      setState(() {
        canPopPage = false;
      });

      SnackbarService.showSnackBar(
        context,
        'loan-finalized-success-snackbar'.i18n(),
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2)).then(
        (_) {
          if (context.mounted) {
            Navigator.of(context).pop(true);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopPage,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'loan-details-title'.i18n(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        body: BlocConsumer<LoanDetailBloc, LoanDetailState>(
          bloc: _bloc,
          listener: _handleLoanDetailsStateListener,
          builder: _getWidgetOnLoanDetailState,
        ),
      ),
    );
  }
}
