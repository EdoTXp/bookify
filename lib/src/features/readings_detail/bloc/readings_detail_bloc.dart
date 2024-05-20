import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/reading_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'readings_detail_event.dart';
part 'readings_detail_state.dart';

class ReadingsDetailBloc
    extends Bloc<ReadingsDetailEvent, ReadingsDetailState> {
  final BookService _bookService;
  final ReadingService _readingService;

  ReadingsDetailBloc(
    this._bookService,
    this._readingService,
  ) : super(ReadingsDetailLoadingState()) {
    on<UpdatedReadingsEvent>(_updatedReadingsEvent);
    on<FinishedReadingsEvent>(_finishedReadingsEvent);
  }

  Future<void> _updatedReadingsEvent(
    UpdatedReadingsEvent event,
    Emitter<ReadingsDetailState> emit,
  ) async {
    try {
      emit(ReadingsDetailLoadingState());

      final readingUpdatedRow = await _readingService.update(
        readingModel: event.readingModel,
      );

      if (readingUpdatedRow != 1) {
        emit(
          ReadingsDetailErrorState(errorMessage: 'Erro ao atualizar a leitura'),
        );
        return;
      }

      emit(ReadingsDetailUpdatedState());
    } on LocalDatabaseException catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorMessage: 'Erro no database: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e',
        ),
      );
    }
  }

  Future<void> _finishedReadingsEvent(
    FinishedReadingsEvent event,
    Emitter<ReadingsDetailState> emit,
  ) async {
    try {
      emit(ReadingsDetailLoadingState());

      final bookUpdatedStatusRow = await _bookService.updateStatus(
        id: event.bookId,
        status: BookStatus.library,
      );

      if (bookUpdatedStatusRow != 1) {
        emit(
          ReadingsDetailErrorState(errorMessage: 'Erro ao atualizar o livro'),
        );
        return;
      }

      final readingDeletedRow = await _readingService.delete(
        readingId: event.readingId,
      );

      if (readingDeletedRow != 1) {
        emit(
          ReadingsDetailErrorState(errorMessage: 'Erro ao finalizar a leitura'),
        );
        return;
      }

      emit(ReadingsDetailFinishedState());
    } on LocalDatabaseException catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorMessage: 'Erro no database: ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        ReadingsDetailErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e',
        ),
      );
    }
  }
}
