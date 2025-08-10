import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reading_page_time_calculator_event.dart';
part 'reading_page_time_calculator_state.dart';

class ReadingPageTimeCalculatorBloc extends Bloc<ReadingPageTimeCalculatorEvent,
    ReadingPageTimeCalculatorState> {
  final UserPageReadingTimeRepository _userPageReadingTimeRepository;

  ReadingPageTimeCalculatorBloc(
    this._userPageReadingTimeRepository,
  ) : super(ReadingPageTimeCalculatorLoadingState()) {
    on<InsertedReadingPageTimeEvent>(_insertedReadingPageTimeEvent);
  }

  Future<void> _insertedReadingPageTimeEvent(
    InsertedReadingPageTimeEvent event,
    Emitter<ReadingPageTimeCalculatorState> emit,
  ) async {
    try {
      emit(ReadingPageTimeCalculatorLoadingState());

      final userPageReading = UserPageReadingTimeModel(
        pageReadingTimeSeconds: event.readingPageTime,
      );

      final userPageReadingTimeInserted =
          await _userPageReadingTimeRepository.setUserPageReadingTime(
        userPageReadingTime: userPageReading,
      );

      if (userPageReadingTimeInserted == 0) {
        emit(
          ReadingPageTimeCalculatorErrorState(
            errorMessage: 'Erro ao inserir o tempo de leitura da página',
          ),
        );
        return;
      }

      emit(ReadingPageTimeCalculatorInsertedState());
    } on StorageException catch (e) {
      emit(
        ReadingPageTimeCalculatorErrorState(
          errorMessage: 'Erro ao inserir o tempo de leitura da página: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        ReadingPageTimeCalculatorErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
