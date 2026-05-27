import 'dart:async';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
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
      emit(
        MyBooksErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        MyBooksErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _searchBooksEvent(
    SearchedBooksEvent event,
    Emitter<MyBooksState> emit,
  ) async {
    try {
      emit(MyBooksLoadingState());

      final books = await _bookService.getBooksByTitle(
        title: event.searchQuery,
      );

      if (books.isEmpty) {
        emit(MyBooksNotFoundState());
        return;
      }

      emit(MyBooksLoadedState(books: books));
    } on LocalDatabaseException catch (e) {
      emit(
        MyBooksErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        MyBooksErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
