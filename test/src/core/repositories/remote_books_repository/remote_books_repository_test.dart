import 'dart:io';

import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'package:bookify/src/core/models/author_model.dart';
import 'package:bookify/src/core/models/category_model.dart';
import 'package:bookify/src/core/repositories/remote_books_repository/remote_books_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/models/books_model_mock.dart';

class RemoteBooksDataSourceMock extends Mock implements RemoteBooksDataSource {}

void main() {
  final booksDataSource = RemoteBooksDataSourceMock();
  final bookRepository = RemoteBooksRepositoryImpl(booksDataSource);

  group('Test all methods of GoogleBookRepository:', () {
    test('Get a List of books by author', () async {
      when(() =>
              booksDataSource.findBooksByAuthor(author: any(named: 'author')))
          .thenAnswer((_) async {
        return booksModelMock
            .map(
              (book) => book.copyWith(
                authors: [AuthorModel(name: 'J. R. R. Tolkien')],
              ),
            )
            .toList();
      });

      final books =
          await bookRepository.findBooksByAuthor(author: 'J.R.R. Tolkien');

      expect(books[0].authors.first.name, 'J. R. R. Tolkien');
      expect(books[1].authors.first.name, 'J. R. R. Tolkien');
    });

    test('Get a book by ISBN', () async {
      when(() => booksDataSource.findBooksByIsbn(isbn: any(named: 'isbn')))
          .thenAnswer((_) async {
        return booksModelMock
            .map(
              (book) => book.copyWith(
                title: 'Arquitetura Limpa',
              ),
            )
            .toList();
      });

      final book = await bookRepository.findBooksByIsbn(isbn: '9788550808161');
      expect(book[0].title, 'Arquitetura Limpa');
    });

    test('Get a List of books by publisher', () async {
      when(() => booksDataSource.findBooksByPublisher(
          publisher: any(named: 'publisher'))).thenAnswer((_) async {
        return booksModelMock
            .map(
              (book) => book.copyWith(
                publisher: 'Alta Books Editora',
              ),
            )
            .toList();
      });

      final books = await bookRepository.findBooksByPublisher(
          publisher: 'Alta Books Editora');

      for (var book in books) {
        expect(book.publisher, 'Alta Books Editora');
      }
    });

    test('Get a list of books', () async {
      when(() => booksDataSource.getAllBooks()).thenAnswer((_) async {
        return booksModelMock;
      });

      final books = await bookRepository.getAllBooks();

      expect(books[0].title, 'title');
      expect(books[1].title, 'title');
    });

    test('Get a list of books by title', () async {
      when(() => booksDataSource.findBooksByTitle(title: any(named: 'title')))
          .thenAnswer((_) async {
        return booksModelMock
            .map(
              (book) => book.copyWith(
                title: 'Arquitetura',
              ),
            )
            .toList();
      });

      final books = await bookRepository.findBooksByTitle(title: 'Arquitetura');

      for (var book in books) {
        expect(book.title.toUpperCase(), contains('ARQUITETURA'));
      }
    });

    test('Get a list of books by category', () async {
      when(() => booksDataSource.findBooksByCategory(
          category: any(named: 'category'))).thenAnswer((_) async {
        return booksModelMock
            .map(
              (book) => book.copyWith(
                categories: [CategoryModel(name: 'Fiction')],
              ),
            )
            .toList();
      });

      final books =
          await bookRepository.findBooksByCategory(category: 'Fiction');

      for (var book in books) {
        expect(book.categories.first.name, 'Fiction');
      }
    });

    test('test a BookException', () async {
      when(() => booksDataSource.getAllBooks())
          .thenThrow(const BookException(''));
      expect(bookRepository.getAllBooks(), throwsA(isA<BookException>()));
    });

    test('test a BookNotFoundException', () async {
      when(() => booksDataSource.getAllBooks())
          .thenThrow(const BookNotFoundException('BookNotFoundException'));
      expect(
          bookRepository.getAllBooks(), throwsA(isA<BookNotFoundException>()));
    });

    test('test a SocketException', () async {
      when(() => booksDataSource.getAllBooks())
          .thenThrow(const SocketException('message'));
      expect(bookRepository.getAllBooks(), throwsA(isA<SocketException>()));
    });

    test('test a generic Exception', () async {
      when(() => booksDataSource.getAllBooks()).thenThrow(Exception());
      expect(bookRepository.getAllBooks(), throwsA(isA<Exception>()));
    });
  });
}
