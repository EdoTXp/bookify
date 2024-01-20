import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:flutter/material.dart';

class BookcaseWidget extends StatelessWidget {
  final BookcaseDto bookcaseDto;
  final VoidCallback onTap;

  const BookcaseWidget({
    super.key,
    required this.bookcaseDto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bookcaseColor = bookcaseDto.bookcase.color;
    final bookcaseTitle = bookcaseDto.bookcase.name;
    final bookcaseDescription = bookcaseDto.bookcase.description;
    final imagePreview = bookcaseDto.bookImagePreview;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 41,
                        width: 100,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: bookcaseColor,
                          border: const Border(
                            left: BorderSide(color: Colors.transparent),
                          ),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          border: const Border(
                            right: BorderSide(color: Colors.transparent),
                          ),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12)),
                        ),
                        child: Text(
                          bookcaseTitle,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    if (imagePreview != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, bottom: 16.0),
                        child: BookWidget(
                          bookImageUrl: imagePreview,
                          height: 150,
                          width: 100,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          height: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: colorScheme.primary),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            bookcaseDescription,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
