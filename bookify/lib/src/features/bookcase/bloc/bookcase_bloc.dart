import 'package:bookify/src/shared/dtos/bookcase_dto.dart';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';

part 'bookcase_event.dart';
part 'bookcase_state.dart';

class BookcaseBloc extends Bloc<BookcaseEvent, BookcaseState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;

  BookcaseBloc(
    this._bookService,
    this._bookcaseService,
  ) : super(BookcaseLoadingState()) {
    on<GotAllBookcasesEvent>(_gotAllBookcasesEvent);
  }

  Future<void> _gotAllBookcasesEvent(
    GotAllBookcasesEvent event,
    Emitter<BookcaseState> emit,
  ) async {
    try {
      emit(BookcaseLoadingState());

      final bookcases = await _bookcaseService.getAllBookcases();

      if (bookcases.isEmpty) {
        emit(BookcaseEmptyState());
        return;
      }

      await _mountBookcaseDto(bookcases, emit);
    } on LocalDatabaseException catch (e) {
      emit(BookcaseErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcaseErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _mountBookcaseDto(
    List<BookcaseModel> bookcases,
    Emitter<BookcaseState> emit,
  ) async {
    final List<BookcaseDto> bookcasesDto = [];

    for (BookcaseModel bookcase in bookcases) {
      if (bookcase.id == null) {
        emit(
          BookcaseErrorState(errorMessage: 'Erro inesperado: ${bookcase.id}'),
        );
        return;
      }

      String? bookId = await _bookcaseService.getBookIdForImagePreview(
        bookcaseId: bookcase.id!,
      );

      String? bookImagePreview;

      if (bookId != null) {
        bookImagePreview = await _bookService.getBookImage(id: bookId);
      }

      final bookcaseDto = BookcaseDto(
        bookcase: bookcase,
        bookImagePreview: bookImagePreview,
      );

      bookcasesDto.add(bookcaseDto);
    }
    emit(BookcaseLoadedState(bookcasesDto: bookcasesDto));
  }
}
