import 'package:bookify/src/features/loan/widgets/loan_widget/widgets/contact_information_widget.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/helpers/date_time_format/date_time_format.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class LoanWidget extends StatelessWidget {
  final LoanDto loan;
  final VoidCallback onTap;

  const LoanWidget({
    super.key,
    required this.loan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(.2),
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  border: const Border(
                    right: BorderSide(color: Colors.transparent),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        BookWidget(
                          bookImageUrl: loan.bookImagePreview,
                          borderColor: Colors.white,
                          withShadow: true,
                          height: 150,
                          width: 100,
                        ),
                        Positioned(
                          top: -3,
                          right: -3,
                          child: CircleAvatar(
                            backgroundImage: (loan.contactDto?.photo != null)
                                ? MemoryImage(loan.contactDto!.photo!)
                                : null,
                            backgroundColor: (loan.contactDto?.photo == null)
                                ? colorScheme.secondary
                                : null,
                            child: (loan.contactDto?.photo == null)
                                ? (Text(
                                    loan.contactDto!.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ContactInformationWidget(
                                iconData: Icons.person_outlined,
                                title: 'Nome',
                                content: loan.contactDto!.name,
                              ),
                              ContactInformationWidget(
                                iconData: Icons.smartphone_outlined,
                                title: 'Contato',
                                content: loan.contactDto!.phoneNumber!,
                              ),
                            ],
                          ),
                          Divider(color: colorScheme.primary.withOpacity(.5)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ContactInformationWidget(
                                iconData: Icons.calendar_month_outlined,
                                title: 'Empréstimo',
                                content:
                                    loan.loanModel.loanDate.toFormattedDate(),
                              ),
                              ContactInformationWidget(
                                iconData: Icons.calendar_month_outlined,
                                title: 'Devolução',
                                content: loan.loanModel.devolutionDate
                                    .toFormattedDate(),
                              ),
                            ],
                          ),
                          Divider(color: colorScheme.primary.withOpacity(.5)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ContactInformationWidget(
                                iconData: Icons.description_outlined,
                                title: 'Observação',
                                content: loan.loanModel.observation,
                              ),
                              ContactInformationWidget(
                                iconData: Icons.book_outlined,
                                title: 'Livro',
                                content: loan.bookTitlePreview,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
