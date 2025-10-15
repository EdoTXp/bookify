import 'dart:io';

import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/repositories/google_book_repository/google_books_repository_impl.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/json/books_json_mock.dart';

class RestClientMock extends Mock implements RestClient {}

void main() {
  final restClient = RestClientMock();
  final bookRepository = GoogleBooksRepositoryImpl(restClient);

  group('Test all methods of GoogleBookRepository:', () {
    test('Get a List of books by author', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
                data: authorJsonBooksMock, // books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ''))
            .data;
      });

      final books =
          await bookRepository.findBooksByAuthor(author: 'J.R.R. Tolkien');

      expect(books[0].authors.first.name, 'J. R. R. Tolkien');
      expect(books[1].authors.first.name, 'J. R. R. Tolkien');
      expect(books[2].authors.first.name, 'J.R.R. Tolkien');
      expect(books[3].authors.first.name, 'J. R. R. Tolkien');
      expect(books[4].authors.first.name, 'J.R.R. Tolkien');
    });

    test('Get a book by ISBN', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
          data: isbnJsonBookMock, //  book of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final book = await bookRepository.findBooksByIsbn(isbn: '9788550808161');
      expect(book[0].title, 'Arquitetura Limpa');
    });

    test('Get a List of books by publisher', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
          data: publisherJsonBooksMock, // books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookRepository.findBooksByPublisher(
          publisher: 'Alta Books Editora');

      for (var book in books) {
        expect(book.publisher, 'Alta Books Editora');
      }
    });

    test('Get a list of books', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
          data: allBooksMock, // books of file books_json_mock.dart

          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookRepository.getAllBooks();

      expect(books[0].title, 'O que é o SUS');
      expect(books[1].title, 'Amamentação');
      expect(books[2].title, 'O trem da Amizade');
      expect(books[3].title, 'Missão prevenir e proteger');
      expect(books[4].title,
          'O Clube dos Caçadores de Códigos 1 - O segredo da chave do Esqueleto');
    });

    test('Get a list of books by title', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
          data: titleBooksMock, // books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookRepository.findBooksByTitle(title: 'Arquitetura');

      for (var book in books) {
        expect(book.title.toUpperCase(), contains('ARQUITETURA'));
      }
    });

    test('Get a list of books by category', () async {
      when(() => restClient.get(any())).thenAnswer((_) async {
        return Response(
                data: categoryBooksMock, //  books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ''))
            .data;
      });

      final books =
          await bookRepository.findBooksByCategory(category: 'Fiction');

      for (var book in books) {
        expect(book.categories.first.name, 'Fiction');
      }
    });

    test('test a BookException', () async {
      when(() => restClient.get(any())).thenThrow(const BookException(''));
      expect(bookRepository.getAllBooks(), throwsA(isA<BookException>()));
    });

    test('test a BookNotFoundException', () async {
      when(() => restClient.get(any()))
          .thenThrow(const BookNotFoundException('BookNotFoundException'));
      expect(
          bookRepository.getAllBooks(), throwsA(isA<BookNotFoundException>()));
    });

    test('test a SocketException', () async {
      when(() => restClient.get(any())).thenThrow(const SocketException('message'));
      expect(bookRepository.getAllBooks(), throwsA(isA<SocketException>()));
    });

    test('test a TypeError expecting an empty list of books', () async {
      when(() => restClient.get(any())).thenThrow(TypeError());
      expect(await bookRepository.getAllBooks(), <BookModel>[]);
    });

    test('test a generic Exception', () async {
      when(() => restClient.get(any())).thenThrow(Exception());
      expect(bookRepository.getAllBooks(), throwsA(isA<Exception>()));
    });
  });
}
