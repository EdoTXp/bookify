import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../book/models/book_model.dart';
import '../../book/services/interfaces/books_service_interface.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final IBooksService _service;

  BookBloc(this._service) : super(BooksLoadingState()) {
    on<GetAllBooksEvent>(_getAllBooks);
    on<FindBookByIsbnEvent>(_findBookByIsbn);
    on<FindBooksByAuthorEvent>(_findBooksByAuthor);
    on<FindBooksByCategoryEvent>(_findBooksByCategory);
    on<FindBooksByPublisherEvent>(_findBooksByPublisher);
    on<FindBooksByTitleEvent>(_findBooksByTitle);
  }

  void _getAllBooks(GetAllBooksEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books = await _service.getAllBooks();
      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  void _findBookByIsbn(FindBookByIsbnEvent event, emit) async {
    emit(BooksLoadingState());
    try {
      final book = await _service.findBookByISBN(isbn: event.isbn);

      emit(SingleBookLoadedState(book: book));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  void _findBooksByAuthor(FindBooksByAuthorEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books = await _service.findBooksByAuthor(author: event.author);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  void _findBooksByCategory(FindBooksByCategoryEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books =
          await _service.findBooksByCategory(category: event.category);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  void _findBooksByPublisher(FindBooksByPublisherEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books =
          await _service.findBooksByPublisher(publisher: event.publisher);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } catch (e) {
      emit(BookErrorSate(message: e.toString()));
    }
  }

  void _findBooksByTitle(FindBooksByTitleEvent event, emit) async {
    emit(BooksLoadingState());

    try {
      final books = await _service.findBooksByTitle(title: event.title);

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
    _service.dispose();
    return super.close();
  }
}
