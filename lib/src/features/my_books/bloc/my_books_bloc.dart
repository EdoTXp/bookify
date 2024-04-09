import 'dart:async';
import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_books_event.dart';
part 'my_books_state.dart';

class MyBooksBloc extends Bloc<MyBooksEvent, MyBooksState> {
  final BookService _bookService;

  MyBooksBloc(this._bookService) : super(MyBooksLoadingState()) {
    on<GotAllBooksEvent>(_getAllBooksEvent);
    on<SearchedBooksEvent>(_searchBooksEvent);
  }

  Future<void> _getAllBooksEvent(
    GotAllBooksEvent event,
    Emitter<MyBooksState> emit,
  ) async {
    try {
      emit(MyBooksLoadingState());

      final books = await _bookService.getAllBook();

      if (books.isEmpty) {
        emit(MyBooksEmptyState());
        return;
      }

      emit(MyBooksLoadedState(books: books));
    } on LocalDatabaseException catch (e) {
      emit(MyBooksErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(MyBooksErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _searchBooksEvent(
    SearchedBooksEvent event,
    Emitter<MyBooksState> emit,
  ) async {
    try {
      emit(MyBooksLoadingState());

      final books = await _bookService.getBookByTitle(title: event.searchQuery);

      if (books.isEmpty) {
        emit(MyBooksNotFoundState());
        return;
      }

      emit(MyBooksLoadedState(books: books));
    } on LocalDatabaseException catch (e) {
      emit(MyBooksErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(MyBooksErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }
}
