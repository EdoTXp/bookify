import 'package:bookify/src/shared/dtos/reading_dto.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class ReadingWidget extends StatelessWidget {
  final ReadingDto readingDto;
  final VoidCallback onTap;

  const ReadingWidget({
    super.key,
    required this.readingDto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final percentReading =
        ((readingDto.reading.pagesReaded / readingDto.book.pageCount) * 100)
            .toInt();

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Tooltip(
                      message: readingDto.book.title,
                      child: BookWidget(
                        bookImageUrl: readingDto.book.imageUrl,
                        height: 150,
                        width: 100,
                        borderColor: Colors.white,
                        withShadow: true,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              readingDto.book.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: deviceWidth,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(22),
                                  ),
                                ),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: deviceWidth * .40),
                                  child: Text(
                                    '$percentReading%',
                                    textScaler: TextScaler.noScaling,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  border: Border.all(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22),
                                  ),
                                ),
                                child: Text(
                                  (readingDto.reading.pagesReaded > 0)
                                      ? 'Continue lendo'
                                      : 'Iniciar Leitura',
                                  textScaler: TextScaler.noScaling,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
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
