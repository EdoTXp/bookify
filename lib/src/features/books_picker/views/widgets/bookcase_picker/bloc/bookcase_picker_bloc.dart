import 'package:bookify/src/core/dtos/bookcase_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookcase_picker_event.dart';
part 'bookcase_picker_state.dart';

class BookcasePickerBloc
    extends Bloc<BookcasePickerEvent, BookcasePickerState> {
  final BookcaseService _bookcaseService;
  final BookService _bookService;

  BookcasePickerBloc(
    this._bookcaseService,
    this._bookService,
  ) : super(BookcasePickerLoadingState()) {
    on<GotAllBookcasesPickerEvent>(_getAllBookcaseEvent);
  }

  Future<void> _getAllBookcaseEvent(
    GotAllBookcasesPickerEvent event,
    Emitter<BookcasePickerState> emit,
  ) async {
    try {
      emit(BookcasePickerLoadingState());

      final bookcases = await _bookcaseService.getAllBookcases();

      if (bookcases.isEmpty) {
        emit(BookcasePickerEmptyState());
        return;
      }

      final List<BookcaseDto> bookcasesDto = [];

      for (BookcaseModel bookcase in bookcases) {
        final bookcaseId = bookcase.id;

        if (bookcaseId == null) {
          emit(
            BookcasePickerErrorState(
                errorMessage: 'Erro inesperado: ${bookcase.id}'),
          );
          return;
        }

        String? bookId = await _bookcaseService.getBookIdForImagePreview(
          bookcaseId: bookcaseId,
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

      if (bookcasesDto.isEmpty) {
        emit(BookcasePickerEmptyState());
        return;
      }

      emit(BookcasePickerLoadedState(bookcasesDto: bookcasesDto));
    } on LocalDatabaseException catch (e) {
      emit(BookcasePickerErrorState(
          errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(BookcasePickerErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }
}
