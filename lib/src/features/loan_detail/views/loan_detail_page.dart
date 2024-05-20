import 'package:bookify/src/features/loan_detail/bloc/loan_detail_bloc.dart';
import 'package:bookify/src/features/loan_detail/views/widgets/loan_detail_loaded_widget.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          loanDto: loanDto,
          onPressedButton: () async {
            await ShowDialogService.showAlertDialog(
              context: context,
              title: 'Finalizar o empréstimo',
              content:
                  'Clicando em "CONFIRMAR" você finalizará este empréstimo.\nVerifique se o livro está em seu possesso antes de finalizar.',
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
        'Emprestímo Finalizado com sucesso!\nAguarde até voltar à página anterior',
        SnackBarType.success,
      );

      await Future.delayed(const Duration(seconds: 2))
          .then((_) => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopPage,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Detalhe do empréstimo',
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
