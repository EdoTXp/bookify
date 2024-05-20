import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'separate_books_picker_event.dart';
part 'separate_books_picker_state.dart';

class SeparateBooksPickerBloc
    extends Bloc<SeparateBooksPickerEvent, SeparateBooksPickerState> {
  final BookService _bookService;

  SeparateBooksPickerBloc(this._bookService)
      : super(SeparateBooksPickerLoadingState()) {
    on<GotAllSeparatedBooksPickerEvent>(_gotAllSeparatedBooksPickerEvent);
  }

  Future<void> _gotAllSeparatedBooksPickerEvent(
      GotAllSeparatedBooksPickerEvent event,
      Emitter<SeparateBooksPickerState> emit) async {
    try {
      emit(SeparateBooksPickerLoadingState());

      final books = await _bookService.getAllBook();

      if (books.isEmpty) {
        emit(SeparateBooksPickerEmptyState());
        return;
      }

      final bookForPicker =
          books.where((book) => book.status == BookStatus.library).toList();

      if (bookForPicker.isEmpty) {
        emit(SeparateBooksPickerEmptyState());
        return;
      }

      emit(SeparateBooksPickerLoadedState(books: bookForPicker));
    } on LocalDatabaseException catch (e) {
      emit(SeparateBooksPickerErrorState(
          errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(SeparateBooksPickerErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }
}
