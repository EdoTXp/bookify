import 'package:bookify/src/shared/widgets/contact_information_widget/contact_information_widget.dart';
import 'package:bookify/src/features/loan_detail/views/widgets/loan_is_late_widget.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/helpers/date_time_format/date_time_format_extension.dart';
import 'package:bookify/src/shared/services/app_services/launcher_service/launcher_service.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';

import 'package:flutter/material.dart';


class LoanDetailLoadedWidget extends StatelessWidget {
  final LoanDto loanDto;
  final VoidCallback onPressedButton;

  const LoanDetailLoadedWidget({
    super.key,
    required this.loanDto,
    required this.onPressedButton,
  });

  bool _isLateDevolutionDate() {
    final loanDateLate = loanDto.loanModel.devolutionDate.add(
      const Duration(
        days: 1,
      ),
    );

    return DateTime.now().isAfter(loanDateLate);
  }

  @override
  Widget build(BuildContext context) {
    final contactName = loanDto.contactDto?.name ?? 'Sem nome';
    final loanIsLate = _isLateDevolutionDate();
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (loanIsLate) ...[
            const LoanIsLateWidget(),
            const SizedBox(
              height: 10,
            ),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BookWidget(
                  height: 270,
                  bookImageUrl: loanDto.bookImagePreview,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ContactCircleAvatar(
                        width: 80,
                        height: 80,
                        name: contactName,
                        photo: loanDto.contactDto?.photo,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.person,
                      title: 'Nome',
                      content: contactName,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.smartphone_outlined,
                      title: 'Contato',
                      content: loanDto.contactDto?.phoneNumber ?? 'Sem número',
                      width: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.book,
                      title: 'Livro',
                      content: loanDto.bookTitlePreview,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.description_outlined,
                      title: 'Observação',
                      content: loanDto.loanModel.observation,
                      width: 200,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContactInformationWidget(
                iconData: Icons.calendar_month_rounded,
                title: 'Empréstimo',
                content: loanDto.loanModel.loanDate.toFormattedDate(),
              ),
              ContactInformationWidget(
                iconData: Icons.calendar_month_rounded,
                title: 'Devolução',
                content: loanDto.loanModel.devolutionDate.toFormattedDate(),
              ),
            ],
          ),
          const Spacer(),
          Divider(
            color: colorScheme.primary,
          ),
          if (loanDto.contactDto?.phoneNumber != null) ...[
            BookifyElevatedButton.expanded(
              onPressed: () async {
                await LauncherService.launchCall(
                  loanDto.contactDto!.phoneNumber!,
                );
              },
              text: 'Ligar para o contato',
              suffixIcon: Icons.call,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
          BookifyElevatedButton.expanded(
            onPressed: onPressedButton,
            text: 'Finalizar Empréstimo',
            suffixIcon: Icons.arrow_circle_down_outlined,
          ),
        ],
      ),
    );
  }
}
