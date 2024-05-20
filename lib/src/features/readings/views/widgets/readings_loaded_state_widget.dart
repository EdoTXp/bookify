import 'package:bookify/src/features/readings/views/widgets/reading_widget.dart';
import 'package:bookify/src/features/readings_detail/views/readings_detail_page.dart';
import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/shared/widgets/buttons/add_new_item_text_button.dart';
import 'package:flutter/material.dart';

class ReadingsLoadedStateWidget extends StatelessWidget {
  final List<ReadingDto> readingsDto;
  final VoidCallback onNewReading;
  final VoidCallback onRefreshPage;

  const ReadingsLoadedStateWidget({
    super.key,
    required this.readingsDto,
    required this.onNewReading,
    required this.onRefreshPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: AddNewItemTextButton(
            label: 'Iniciar uma leitura',
            onPressed: onNewReading,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: readingsDto.length,
            padding: const EdgeInsets.symmetric(
              vertical: 25.0,
              horizontal: 5.0,
            ),
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReadingWidget(
                  readingDto: readingsDto[index],
                  onTap: () async {
                    await Navigator.of(context).pushNamed(
                      ReadingsDetailPage.routeName,
                      arguments: readingsDto[index],
                    );

                    onRefreshPage();
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
