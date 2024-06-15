import 'package:bookify/src/features/loan/widgets/loan_widget/loan_widget.dart';
import 'package:bookify/src/features/loan_detail/views/loan_detail_page.dart';
import 'package:bookify/src/features/loan_insertion/views/loan_insertion_page.dart';
import 'package:bookify/src/core/dtos/loan_dto.dart';
import 'package:bookify/src/shared/widgets/buttons/add_new_item_text_button.dart';
import 'package:flutter/material.dart';

class LoanLoadedStateWidget extends StatelessWidget {
  final List<LoanDto> loansDto;
  final VoidCallback refreshPage;

  const LoanLoadedStateWidget({
    super.key,
    required this.loansDto,
    required this.refreshPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: AddNewItemTextButton(
            label: 'Emprestar um livro',
            onPressed: () async {
              final loanInserted = await Navigator.pushNamed(
                context,
                LoanInsertionPage.routeName,
              ) as bool?;

              if (loanInserted != null && loanInserted) {
                refreshPage();
              }
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: loansDto.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoanWidget(
                  loan: loansDto[index],
                  onTap: () async {
                    final loanChanged = await Navigator.pushNamed(
                      context,
                      LoanDetailPage.routeName,
                      arguments: loansDto[index].loanModel.id!,
                    ) as bool?;

                    if (loanChanged != null && loanChanged) {
                      refreshPage();
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
