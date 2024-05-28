import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/repositories/user_hour_time_repository/user_hour_time_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'readings_timer_event.dart';
part 'readings_timer_state.dart';

class ReadingsTimerBloc extends Bloc<ReadingsTimerEvent, ReadingsTimerState> {
  final UserHourTimeRepository _userHourTimeRepository;

  ReadingsTimerBloc(this._userHourTimeRepository)
      : super(ReadingsTimerLoadingState()) {
    on<GotReadingsUserTimerEvent>(_gotReadingsUserTimerEvent);
  }

  Future<void> _gotReadingsUserTimerEvent(
    GotReadingsUserTimerEvent event,
    Emitter<ReadingsTimerState> emit,
  ) async {
    try {
      emit(ReadingsTimerLoadingState());

      final userHourTime = await _userHourTimeRepository.getUserHourTime();

      if (userHourTime == null) {
        emit(ReadingsTimerEmptyState());
        return;
      }

      final timeDifferenceInSeconds = userHourTime.timeDifferenceInSeconds;

      emit(
        ReadingsTimerLoadedState(
          initialUserTimerInSeconds: timeDifferenceInSeconds,
        ),
      );
    } on StorageException catch (e) {
      emit(
        ReadingsTimerErrorState(
          errorMessage: 'Erro ao buscar a hora do timer: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        ReadingsTimerErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
