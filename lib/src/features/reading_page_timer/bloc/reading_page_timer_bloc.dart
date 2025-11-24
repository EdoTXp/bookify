import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reading_page_timer_event.dart';
part 'reading_page_timer_state.dart';

class ReadingPageTimerBloc
    extends Bloc<ReadingPageTimerEvent, ReadingPageTimerState> {
  final UserPageReadingTimeRepository _userPageReadingTimeRepository;

  ReadingPageTimerBloc(
    this._userPageReadingTimeRepository,
  ) : super(ReadingPageTimerLoadingState()) {
    on<InsertedReadingPageTimeEvent>(_insertedReadingPageTimeEvent);
  }

  Future<void> _insertedReadingPageTimeEvent(
    InsertedReadingPageTimeEvent event,
    Emitter<ReadingPageTimerState> emit,
  ) async {
    try {
      emit(ReadingPageTimerLoadingState());

      final userPageReading = UserPageReadingTimeModel(
        pageReadingTimeSeconds: event.readingPageTime,
      );

      final userPageReadingTimeInserted =
          await _userPageReadingTimeRepository.setUserPageReadingTime(
        userPageReadingTime: userPageReading,
      );

      if (userPageReadingTimeInserted == 0) {
        emit(
          ReadingPageTimerErrorState(
            errorMessage: 'Erro ao inserir o tempo de leitura da página',
          ),
        );
        return;
      }

      emit(ReadingPageTimerInsertedState());
    } on StorageException catch (e) {
      emit(
        ReadingPageTimerErrorState(
          errorMessage: 'Erro ao inserir o tempo de leitura da página: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        ReadingPageTimerErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
