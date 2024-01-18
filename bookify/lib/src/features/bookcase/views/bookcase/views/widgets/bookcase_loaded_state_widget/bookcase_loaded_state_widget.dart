import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:flutter/material.dart';

class BookcaseLoadedStateWidget extends StatelessWidget {
  final List<BookcaseDto> bookcasesDto;

  const BookcaseLoadedStateWidget({
    super.key,
    required this.bookcasesDto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
