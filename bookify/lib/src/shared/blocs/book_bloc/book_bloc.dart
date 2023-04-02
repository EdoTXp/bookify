// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

import '../../models/book_model.dart';
import '../../interfaces/books_repository_interface.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final IBooksRepository _booksRepository;

  BookBloc(this._booksRepository) : super(BooksLoadingState()) {
    on<GetAllBooksEvent>(_getAllBooks);
    on<FindBookByIsbnEvent>(_findBookByIsbn);
    on<FindBooksByAuthorEvent>(_findBooksByAuthor);
    on<FindBooksByCategoryEvent>(_findBooksByCategory);
    on<FindBooksByPublisherEvent>(_findBooksByPublisher);
    on<FindBooksByTitleEvent>(_findBooksByTitle);
  }

  Future<void> _getAllBooks(GetAllBooksEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books = await _booksRepository.getAllBooks();
      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on SocketException catch (socketException) {
      emit(BookErrorSate(message: socketException.message));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBookByIsbn(FindBookByIsbnEvent event, emit) async {
    emit(BooksLoadingState());
    try {
      final book = await _booksRepository.findBookByISBN(isbn: event.isbn);

      emit(SingleBookLoadedState(book: book));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByAuthor(FindBooksByAuthorEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books = await _booksRepository.findBooksByAuthor(author: event.author);

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
      FindBooksByCategoryEvent event, emit) async {
    emit(BooksLoadingState());

    try {
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
      FindBooksByPublisherEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books =
          await _booksRepository.findBooksByPublisher(publisher: event.publisher);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  Future<void> _findBooksByTitle(FindBooksByTitleEvent event, emit) async {
    emit(BooksLoadingState());

    try {
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
