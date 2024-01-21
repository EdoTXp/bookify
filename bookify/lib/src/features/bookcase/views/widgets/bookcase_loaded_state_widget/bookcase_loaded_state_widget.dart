import 'package:bookify/src/features/bookcase/views/widgets/bookcase_widget/bookcase_widget.dart';
import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:flutter/material.dart';

class BookcaseLoadedStateWidget extends StatelessWidget {
  final List<BookcaseDto> bookcasesDto;
  final void Function() onRefresh;

  const BookcaseLoadedStateWidget({
    super.key,
    required this.bookcasesDto,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: colorScheme.secondary,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: colorScheme.secondary,
              ),
              label: const Text(
                'Adicionar uma nova estante',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 5.0,
              ),
              itemCount: bookcasesDto.length,
              itemBuilder: (_, index) {
                return BookcaseWidget(
                  bookcaseDto: bookcasesDto[index],
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
