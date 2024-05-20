import 'package:bookify/src/core/dtos/reading_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/reading_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/reading_services/reading_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'readings_event.dart';
part 'readings_state.dart';

class ReadingsBloc extends Bloc<ReadingsEvent, ReadingsState> {
  final BookService _bookService;
  final ReadingService _readingServices;

  ReadingsBloc(
    this._bookService,
    this._readingServices,
  ) : super(ReadingsLoadingState()) {
    on<GotAllReadingsEvent>(_gotAllReadingsEvent);
    on<FindedReadingByBookTitleEvent>(_findedReadingByBookTitleEvent);
  }

  Future<void> _gotAllReadingsEvent(
    GotAllReadingsEvent event,
    Emitter<ReadingsState> emit,
  ) async {
    try {
      emit(ReadingsLoadingState());

      final readings = await _readingServices.getAll();

      if (readings.isEmpty) {
        emit(ReadingsEmptyState());
        return;
      }

      await _mountReadingsDto(readings, emit);
    } on LocalDatabaseException catch (e) {
      emit(ReadingsErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(ReadingsErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _findedReadingByBookTitleEvent(
    FindedReadingByBookTitleEvent event,
    Emitter<ReadingsState> emit,
  ) async {
    try {
      emit(ReadingsLoadingState());

      final readings = await _readingServices.getReadingsByBookTitle(
        title: event.searchQueryName,
      );

      if (readings.isEmpty) {
        emit(ReadingsNotFoundState());
        return;
      }

      await _mountReadingsDto(readings, emit);
    } on LocalDatabaseException catch (e) {
      emit(ReadingsErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(ReadingsErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _mountReadingsDto(
    List<ReadingModel> readings,
    Emitter<ReadingsState> emit,
  ) async {
    final List<ReadingDto> readingsDto = [];

    for (ReadingModel reading in readings) {
      if (reading.id == null) {
        emit(
            ReadingsErrorState(errorMessage: 'Erro inesperado: ${reading.id}'));
        return;
      }

      final book = await _bookService.getBookById(id: reading.bookId);

      final readingDto = ReadingDto(
        reading: reading,
        book: book,
      );

      readingsDto.add(readingDto);
    }

    emit(ReadingsLoadedState(readingsDto: readingsDto));
  }
}
