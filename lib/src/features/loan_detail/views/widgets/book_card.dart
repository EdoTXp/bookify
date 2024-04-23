import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/contact_information_widget/contact_information_widget.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String bookUrl;
  final String bookTitle;
  final String observation;
  final String loanDate;
  final String devolutionDate;

  const BookCard({
    super.key,
    required this.bookUrl,
    required this.bookTitle,
    required this.observation,
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
        color: colorScheme.secondary.withOpacity(.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BookWidget(
                height: 120,
                width: 85,
                bookImageUrl: bookUrl,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContactInformationWidget(
                      iconData: Icons.book_rounded,
                      title: 'Título',
                      content: bookTitle,
                      width: mediaQueryWidth,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ContactInformationWidget(
                      iconData: Icons.description_rounded,
                      title: 'Observação',
                      content: observation,
                      width: mediaQueryWidth,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContactInformationWidget(
                          iconData: Icons.calendar_month_rounded,
                          title: 'Empréstimo',
                          content: loanDate,
                        ),
                        ContactInformationWidget(
                          iconData: Icons.calendar_month_rounded,
                          title: 'Devolução',
                          content: devolutionDate,
                        ),
                      ],
                    )
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
