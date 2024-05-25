import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/core/models/user_page_reading_time_model.dart';
import 'package:bookify/src/core/repositories/user_page_reading_time_repository/user_page_reading_time_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_pages_reading_time_event.dart';
part 'book_pages_reading_time_state.dart';

class BookPagesReadingTimeBloc
    extends Bloc<BookPagesReadingTimeEvent, BookPagesReadingTimeState> {
  final UserPageReadingTimeRepository _userPageReadingTimeRepository;

  BookPagesReadingTimeBloc(
    this._userPageReadingTimeRepository,
  ) : super(BookPagesReadingTimeLoadingState()) {
    on<GotBookPagesReadingTimeEvent>(_gotBookPagesReadingTimeEvent);
  }

  Future<void> _gotBookPagesReadingTimeEvent(
    GotBookPagesReadingTimeEvent event,
    Emitter<BookPagesReadingTimeState> emit,
  ) async {
    try {
      emit(BookPagesReadingTimeLoadingState());

      final userPageReadingTime =
          await _userPageReadingTimeRepository.getUserPageReadingTime();

      emit(
        BookPagesReadingTimeLoadedState(
          userPageReadingTime: userPageReadingTime,
        ),
      );
    } on StorageException catch (e) {
      emit(
        BookPagesReadingTimeErrorState(
          errorMessage: 'Erro ao buscar o tempo de leitura da página: $e',
        ),
      );
    } on Exception catch (e) {
      emit(
        BookPagesReadingTimeErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
