import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/contact_information_widget/contact_information_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:localization/localization.dart';

class BookCard extends StatelessWidget {
  final String bookUrl;
  final String bookTitle;
  final String? observation;
  final String loanDate;
  final String devolutionDate;

  const BookCard({
    super.key,
    required this.bookUrl,
    required this.bookTitle,
    this.observation,
    required this.loanDate,
    required this.devolutionDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQueryWidth = MediaQuery.sizeOf(context).width;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(
          alpha: .3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BookWidget(
                height: 150,
                width: 100,
                bookImageUrl: bookUrl,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    ContactInformationWidget(
                      iconData: Icons.book_rounded,
                      title: 'title-label'.i18n(),
                      content: bookTitle,
                      width: mediaQueryWidth,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.description_rounded,
                      title: 'observation-label'.i18n(),
                      content: observation ?? '...',
                      width: mediaQueryWidth,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.calendar_month_rounded,
                      title: 'loan-label'.i18n(),
                      content: loanDate,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.calendar_month_rounded,
                      title: 'devolution-date-label'.i18n(),
                      content: devolutionDate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
