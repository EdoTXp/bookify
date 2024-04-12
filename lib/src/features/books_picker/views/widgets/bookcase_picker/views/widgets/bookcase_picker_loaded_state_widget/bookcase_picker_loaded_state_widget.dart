import 'package:bookify/src/features/books_picker/views/widgets/book_on_bookcase_picker/views/book_on_bookcase_widget.dart';
import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/widgets/bookcase_widget/bookcase_widget.dart';
import 'package:flutter/material.dart';

class BookcasePickerLoadedStateWidget extends StatelessWidget {
  final List<BookcaseDto> bookcasesDto;
  final void Function(BookModel bookModel) onSelectBookModel;

  const BookcasePickerLoadedStateWidget({
    super.key,
    required this.bookcasesDto,
    required this.onSelectBookModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookcasesDto.length,
      padding: const EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 5.0,
      ),
      itemBuilder: (context, index) {
        return BookcaseWidget(
          bookcaseDto: bookcasesDto[index],
          onTap: () async {
            final book = await showModalBottomSheet(
              context: context,
              constraints: BoxConstraints.loose(
                Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.75,
                ),
              ),
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => BookOnBookcaseWidget(
                bookcaseId: bookcasesDto[index].bookcase.id!,
              ),
            ) as BookModel?;

            if (book != null) {
              onSelectBookModel(book);
            }
          },
        );
      },
    );
  }
}
