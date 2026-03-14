import 'package:bookify/src/core/enums/rest_client_error_code.dart';
import 'package:bookify/src/core/errors/rest_client_exception/rest_client_exception.dart';
import 'package:bookify/src/core/repositories/remote_books_repository/remote_books_repository.dart';
import 'package:bookify/src/core/utils/verifier/isbn_verifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/core/models/book_model.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final RemoteBooksRepository _booksRepository;

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

      final books = await _booksRepository.getAllBooks();

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
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
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _findBooksByAuthor(
    FoundBooksByAuthorEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByAuthor(
        author: event.author,
      );

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _findBooksByCategory(
    FoundBooksByCategoryEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByCategory(
        category: event.category,
      );

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _findBooksByPublisher(
    FoundBooksByPublisherEvent event,
    Emitter<BookState> emit,
  ) async {
    try {
      emit(BooksLoadingState());

      final books = await _booksRepository.findBooksByPublisher(
        publisher: event.publisher,
      );

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
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
        emit(
          BookErrorState(
            errorCode: RestClientErrorCode.invalidInput,
            errorMessage: 'Invalid ISBN provided',
          ),
        );
        return;
      }

      final books = await _booksRepository.findBooksByIsbn(isbn: isbn);

      if (books.isEmpty) {
        emit(BookEmptyState());
        return;
      }

      emit(BooksLoadedState(books: books));
    } on RestClientException catch (e) {
      emit(
        BookErrorState(
          errorCode: e.code,
          errorMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        BookErrorState(
          errorCode: RestClientErrorCode.unknown,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
