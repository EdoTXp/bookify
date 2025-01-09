import 'package:bookify/src/core/dtos/bookcase_dto.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BookcaseWidget extends StatelessWidget {
  final BookcaseDto bookcaseDto;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BookcaseWidget({
    super.key,
    required this.bookcaseDto,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.sizeOf(context).width;

    final bookcaseColor = bookcaseDto.bookcase.color;
    final bookcaseTitle = bookcaseDto.bookcase.name;
    final bookcaseDescription = bookcaseDto.bookcase.description;
    final imagePreview = bookcaseDto.bookImagePreview;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 10.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: .2,
              ),
              border: Border.all(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 40,
                      width: deviceWidth,
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
                      child: Container(
                        margin: EdgeInsets.only(left: deviceWidth * .33),
                        child: Text(
                          bookcaseTitle,
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 120,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: bookcaseColor,
                        border: const Border(
                          left: BorderSide(color: Colors.transparent),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      if (imagePreview != null) ...[
                        BookWidget(
                          bookImageUrl: imagePreview,
                          height: 150,
                          width: 100,
                          borderColor: Colors.white,
                          withShadow: true,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.primary),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            bookcaseDescription,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
