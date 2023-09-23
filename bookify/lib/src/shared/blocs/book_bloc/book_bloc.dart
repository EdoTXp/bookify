import 'dart:io';

import 'package:bookify/src/shared/repositories/book_repository/books_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/shared/models/book_model.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BooksRepository _booksRepository;

  /// Variable that avoids making many requests to the API for the same books.
  List<BookModel>? cachedBooksList;

  BookBloc(this._booksRepository) : super(BooksLoadingState()) {
    on<GotAllBooksEvent>(_getAllBooks);
    on<FindedBookByIsbnEvent>(_findBookByIsbn);
    on<FindedBooksByAuthorEvent>(_findBooksByAuthor);
    on<FindedBooksByCategoryEvent>(_findBooksByCategory);
    on<FindedBooksByPublisherEvent>(_findBooksByPublisher);
    on<FindedBooksByTitleEvent>(_findBooksByTitle);
  }

  Future<void> _getAllBooks(GotAllBooksEvent event, emit) async {
    try {
      emit(BooksLoadingState());

      if (cachedBooksList != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(BooksLoadedState(books: cachedBooksList!));
        return;
      }

      final books = await _booksRepository.getAllBooks();

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      cachedBooksList = books;
      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(message: socketException.message));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBookByIsbn(FindedBookByIsbnEvent event, emit) async {
    try {
      emit(BooksLoadingState());
      final books = await _booksRepository.findBookByISBN(isbn: event.isbn);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByAuthor(FindedBooksByAuthorEvent event, emit) async {
    try {
      emit(BooksLoadingState());

      final books =
          await _booksRepository.findBooksByAuthor(author: event.author);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByCategory(
      FindedBooksByCategoryEvent event, emit) async {
    try {
      emit(BooksLoadingState());

      final books =
          await _booksRepository.findBooksByCategory(category: event.category);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByPublisher(
      FindedBooksByPublisherEvent event, emit) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByPublisher(
          publisher: event.publisher);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByTitle(FindedBooksByTitleEvent event, emit) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByTitle(title: event.title);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _booksRepository.dispose();
    return super.close();
  }
}
