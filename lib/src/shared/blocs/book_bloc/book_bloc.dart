import 'dart:io';

import 'package:bookify/src/core/repositories/google_book_repository/google_books_repository.dart';
import 'package:bookify/src/core/utils/verifier/isbn_verifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/core/models/book_model.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GoogleBooksRepository _booksRepository;

  /// Variable that avoids making many requests to the API for the same books.
  List<BookModel>? _cachedBooksList;

  BookBloc(this._booksRepository) : super(BooksLoadingState()) {
    on<GotAllBooksEvent>(_getAllBooks);
    on<FoundBooksByTitleEvent>(_findBooksByTitle);
    on<FoundBooksByAuthorEvent>(_findBooksByAuthor);
    on<FoundBooksByCategoryEvent>(_findBooksByCategory);
    on<FoundBooksByPublisherEvent>(_findBooksByPublisher);
    on<FoundBooksByIsbnEvent>(_findBooksByIsbn);
  }

  Future<void> _getAllBooks(
    GotAllBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      if (_cachedBooksList != null) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(BooksLoadedState(books: _cachedBooksList!));
        return;
      }

      final books = await _booksRepository.getAllBooks();

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      _cachedBooksList = books;
      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }

  Future<void> _findBooksByTitle(
    FoundBooksByTitleEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByTitle(title: event.title);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }
      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }

  Future<void> _findBooksByAuthor(
    FoundBooksByAuthorEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books =
          await _booksRepository.findBooksByAuthor(author: event.author);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }

  Future<void> _findBooksByCategory(
    FoundBooksByCategoryEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books =
          await _booksRepository.findBooksByCategory(category: event.category);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }

  Future<void> _findBooksByPublisher(
    FoundBooksByPublisherEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByPublisher(
          publisher: event.publisher);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }

  Future<void> _findBooksByIsbn(
    FoundBooksByIsbnEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final verifier = IsbnVerifier();
      String? isbn = verifier.verifyIsbn(event.isbn);
      if (isbn == null) {
        emit(BookErrorSate(errorMessage: 'Digite um ISBN Válido'));
        return;
      }

      final books = await _booksRepository.findBooksByIsbn(isbn: isbn);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(errorMessage: socketException.message));
    } catch (e) {
      emit(BookErrorSate(errorMessage: e.toString()));
    }
  }
}
