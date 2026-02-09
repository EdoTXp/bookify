import 'dart:io';

import 'package:bookify/src/core/data_sources/remote_books_data_source/google_books_data_source_impl.dart';
import 'package:bookify/src/core/errors/book_exception/book_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/rest_client/rest_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/json/books_json_mock.dart';

class RestClientMock extends Mock implements RestClient {}

void main() {
  final restClient = RestClientMock();
  final bookDataSource = GoogleBooksDataSourceImpl(restClient);

  group('Test all methods of RemoteBookDataSourceImpl:', () {
    test('Get a List of books by author', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: authorJsonBooksMock, // books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookDataSource.findBooksByAuthor(
        author: 'J.R.R. Tolkien',
      );

      expect(books[0].authors.first.name, 'J. R. R. Tolkien');
      expect(books[1].authors.first.name, 'J. R. R. Tolkien');
      expect(books[2].authors.first.name, 'J.R.R. Tolkien');
      expect(books[3].authors.first.name, 'J. R. R. Tolkien');
      expect(books[4].authors.first.name, 'J.R.R. Tolkien');
    });

    test('Get a book by ISBN', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: isbnJsonBookMock, //  book of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final book = await bookDataSource.findBooksByIsbn(isbn: '9788550808161');
      expect(book[0].title, 'Arquitetura Limpa');
    });

    test('Get a List of books by publisher', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: publisherJsonBooksMock, // books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookDataSource.findBooksByPublisher(
        publisher: 'Alta Books Editora',
      );

      for (var book in books) {
        expect(book.publisher, 'Alta Books Editora');
      }
    });

    test('Get a list of books', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: allBooksMock, // books of file books_json_mock.dart

          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookDataSource.getAllBooks();

      expect(books[0].title, 'O que é o SUS');
      expect(books[1].title, 'Amamentação');
      expect(books[2].title, 'O trem da Amizade');
      expect(books[3].title, 'Missão prevenir e proteger');
      expect(
        books[4].title,
        'O Clube dos Caçadores de Códigos 1 - O segredo da chave do Esqueleto',
      );
    });

    test('Get a list of books by title', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: titleBooksMock, // books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookDataSource.findBooksByTitle(title: 'Arquitetura');

      for (var book in books) {
        expect(book.title.toUpperCase(), contains('ARQUITETURA'));
      }
    });

    test('Get a list of books by category', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async {
        return Response(
          data: categoryBooksMock, //  books of file books_json_mock.dart
          requestOptions: RequestOptions(path: ''),
        ).data;
      });

      final books = await bookDataSource.findBooksByCategory(
        category: 'Fiction',
      );

      for (var book in books) {
        expect(book.categories.first.name, 'Fiction');
      }
    });

    test('test a BookException', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(const BookException(''));
      expect(bookDataSource.getAllBooks(), throwsA(isA<BookException>()));
    });

    test('test a BookNotFoundException', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(const BookNotFoundException('BookNotFoundException'));
      expect(
        bookDataSource.getAllBooks(),
        throwsA(isA<BookNotFoundException>()),
      );
    });

    test('test a SocketException', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(const SocketException('message'));
      expect(bookDataSource.getAllBooks(), throwsA(isA<SocketException>()));
    });

    test('test a TypeError expecting an empty list of books', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(TypeError());
      expect(await bookDataSource.getAllBooks(), <BookModel>[]);
    });

    test('test a generic Exception', () async {
      when(
        () => restClient.get(
          baseUrl: any(named: 'baseUrl'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception());
      expect(bookDataSource.getAllBooks(), throwsA(isA<Exception>()));
    });
  });
}
