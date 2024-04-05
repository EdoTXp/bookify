import 'dart:ui';

import 'package:bookify/src/features/loan/widgets/loan_widget/widgets/contact_information_widget.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/helpers/date_time_format/date_time_format.dart';
import 'package:bookify/src/shared/theme/colors.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:flutter/material.dart';

class LoanWidget extends StatelessWidget {
  final LoanDto loan;
  final VoidCallback onTap;

  const LoanWidget({
    super.key,
    required this.loan,
    required this.onTap,
  });

  bool _isLateDevolutionDate() {
    final loanDateLate = loan.loanModel.devolutionDate.add(
      const Duration(
        days: 1,
      ),
    );

    return DateTime.now().isAfter(loanDateLate);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLateDevolutionDate = _isLateDevolutionDate();

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
                        ImageFiltered(
                          enabled: isLateDevolutionDate,
                          imageFilter: ImageFilter.blur(
                            sigmaX: 2.0,
                            sigmaY: 2.0,
                          ),
                          child: BookWidget(
                            bookImageUrl: loan.bookImagePreview,
                            borderColor: Colors.white,
                            withShadow: true,
                            height: 150,
                            width: 100,
                          ),
                        ),
                        Positioned(
                          top: -3,
                          right: -3,
                          child: ContactCircleAvatar(
                            name: loan.contactDto!.name,
                            photo: loan.contactDto!.photo,
                          ),
                        ),
                        if (isLateDevolutionDate)
                          const Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            right: 0,
                            child: Tooltip(
                              message: 'Empréstimo atrasado',
                              child: Icon(
                                Icons.warning_amber_rounded,
                                size: 62,
                                color: AppColor.bookifyWarningColor,
                              ),
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
