import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_on_bookcase_picker_event.dart';
part 'book_on_bookcase_picker_state.dart';

class BookOnBookcasePickerBloc
    extends Bloc<BookOnBookcasePickerEvent, BookOnBookcasePickerState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;

  BookOnBookcasePickerBloc(
    this._bookService,
    this._bookcaseService,
  ) : super(BookOnBookcasePickerLoadingState()) {
    on<GotAllBookOnBookcasePickerEvent>(_gotAllBookOnBookcasePickerEvent);
  }

  Future<void> _gotAllBookOnBookcasePickerEvent(
    GotAllBookOnBookcasePickerEvent event,
    Emitter<BookOnBookcasePickerState> emit,
  ) async {
    try {
      emit(BookOnBookcasePickerLoadingState());

      final bookcaseRelationships = await _bookcaseService
          .getAllBookcaseRelationships(bookcaseId: event.bookcaseId);

      if (bookcaseRelationships.isEmpty) {
        emit(BookOnBookcasePickerEmptyState());
        return;
      }

      final books = <BookModel>[];

      for (var relationship in bookcaseRelationships) {
        final bookModel = await _bookService.getBookById(
          id: relationship['bookId'] as String,
        );

        if (bookModel.status == BookStatus.library) {
          books.add(bookModel);
        }
      }

      if (books.isEmpty) {
        emit(BookOnBookcasePickerEmptyState());
        return;
      }

      emit(BookOnBookcasePickerLoadedState(books: books));
    } on LocalDatabaseException catch (e) {
      emit(
        BookOnBookcasePickerErrorState(
            errorMessage: 'Erro no database: ${e.message}'),
      );
    } catch (e) {
      emit(
        BookOnBookcasePickerErrorState(
            errorMessage: 'Ocorreu um erro não esperado: $e'),
      );
    }
  }
}
