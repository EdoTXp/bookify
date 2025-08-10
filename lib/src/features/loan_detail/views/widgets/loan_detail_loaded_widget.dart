import 'package:bookify/src/features/loan_detail/views/widgets/book_card.dart';
import 'package:bookify/src/features/loan_detail/views/widgets/contact_card.dart';
import 'package:bookify/src/features/loan_detail/views/widgets/loan_is_late_widget.dart';
import 'package:bookify/src/core/dtos/loan_dto.dart';
import 'package:bookify/src/core/helpers/date_time_format/date_time_format_extension.dart';
import 'package:bookify/src/core/services/app_services/launcher_service/launcher_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class LoanDetailLoadedWidget extends StatelessWidget {
  final LoanDto loanDto;
  final VoidCallback onPressedButton;

  const LoanDetailLoadedWidget({
    super.key,
    required this.loanDto,
    required this.onPressedButton,
  });

  @override
  Widget build(BuildContext context) {
    final loanIsLate = loanDto.loanIsLate;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loanIsLate) ...[
              const LoanIsLateWidget(),
              const SizedBox(
                height: 20,
              ),
            ],
            Text(
              'book-label'.i18n(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            BookCard(
              bookUrl: loanDto.bookImagePreview,
              bookTitle: loanDto.bookTitlePreview,
              observation: loanDto.loanModel.observation,
              loanDate: loanDto.loanModel.loanDate.toFormattedDate(),
              devolutionDate:
                  loanDto.loanModel.devolutionDate.toFormattedDate(),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'contact-label'.i18n(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ContactCard(
              name: loanDto.contactDto?.name,
              photo: loanDto.contactDto?.photo,
              phone: loanDto.contactDto?.phoneNumber,
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              color: colorScheme.primary,
            ),
            const SizedBox(
              height: 20,
            ),
            if (loanDto.contactDto?.phoneNumber != null) ...[
              BookifyOutlinedButton.expanded(
                onPressed: () async {
                  await LauncherService.launchCall(
                    loanDto.contactDto!.phoneNumber!,
                  );
                },
                text: 'call-the-contact-button'.i18n(),
                suffixIcon: Icons.call_rounded,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            BookifyElevatedButton.expanded(
              key: const Key('Finish loan Button'),
              onPressed: onPressedButton,
              text: 'finish-loan-button'.i18n(),
              suffixIcon: Icons.arrow_circle_down_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
