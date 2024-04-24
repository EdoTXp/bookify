import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/reading_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/reading_services/reading_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'readings_insertion_event.dart';
part 'readings_insertion_state.dart';

class ReadingsInsertionBloc
    extends Bloc<ReadingsInsertionEvent, ReadingsInsertionState> {
  final BookService _bookService;
  final ReadingService _readingService;

  ReadingsInsertionBloc(
    this._bookService,
    this._readingService,
  ) : super(ReadingsInsertionLoadingState()) {
    on<InsertedReadingsEvent>(_insertedReadingsEvent);
  }

  Future<void> _insertedReadingsEvent(
    InsertedReadingsEvent event,
    Emitter<ReadingsInsertionState> emit,
  ) async {
    try {
      emit(ReadingsInsertionLoadingState());

      final pagesUpdated = event.pagesUpdated;
      if (pagesUpdated != null) {
        final bookPageCountUpdated = await _bookService.updatePageCount(
          id: event.bookId,
          pageCount: pagesUpdated,
        );

        if (bookPageCountUpdated != 1) {
          emit(
            ReadingsInsertionErrorState(
              errorMessage: 'Ocorreu um erro ao atualizar as páginas do livro.',
            ),
          );
          return;
        }
      }

      final bookStatusUpdated = await _bookService.updateStatus(
        id: event.bookId,
        status: BookStatus.reading,
      );
      if (bookStatusUpdated != 1) {
        emit(
          ReadingsInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao atualizar o livro.',
          ),
        );
        return;
      }

      final newReadingId = await _readingService.insert(
        readingModel: ReadingModel(
          pagesReaded: 0,
          bookId: event.bookId,
        ),
      );

      if (newReadingId < 1) {
        emit(
          ReadingsInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao inserir a leitura.',
          ),
        );
        return;
      }

      emit(ReadingsInsertionInsertedState());  
    } on LocalDatabaseException catch (e) {
      emit(ReadingsInsertionErrorState(
          errorMessage: 'Ocorreu um erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(ReadingsInsertionErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e'));
    }
  }
}
