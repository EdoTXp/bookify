import 'package:bookify/src/features/book/services/google_books_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/books_json_mock.dart';
import '../../../mocks/dio_http_service_mock.dart';

void main() {
  final dio = DioHttpServiceMock();
  final service = GoogleBookService(dio);

  group('Test all methods of GoogleBookService:', () {
    test('Get a List of books by author', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data: authorJsonBooksMock, // books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final books = await service.findBooksByAuthor(author: 'J.R.R. Tolkien');

      expect(books[0].authors.first, 'J. R. R. Tolkien');
      expect(books[1].authors.first, 'J. R. R. Tolkien');
      expect(books[2].authors.first, 'J.R.R. Tolkien');
      expect(books[3].authors.first, 'J. R. R. Tolkien');
      expect(books[4].authors.first, 'J.R.R. Tolkien');
    });

    test('Get a book by ISBN', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data: isbnJsonBookMock, //  book of file books_json_mock.dart
                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final book = await service.findBookByISBN(isbn: 9788550808161);
      expect(book.title, 'Arquitetura Limpa');
    });

    test('Get a List of books by publisher', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data:
                    publisherJsonBooksMock, // books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final books =
          await service.findBooksByPublisher(publisher: 'Alta Books Editora');

      for (var book in books) {
        expect(book.publisher, 'Alta Books Editora');
      }
    });

    test('Get a list of books', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data: allBooksMock, // books of file books_json_mock.dart

                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final books = await service.getAllBooks();

      expect(books[0].title, 'O que é o SUS');
      expect(books[1].title, 'Amamentação');
      expect(books[2].title, 'O trem da Amizade');
      expect(books[3].title, 'Missão prevenir e proteger');
      expect(books[4].title,
          'O Clube dos Caçadores de Códigos 1 - O segredo da chave do Esqueleto');
    });

    test('Get a list of books by title', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data: titleBooksMock, // books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final books = await service.findBooksByTitle(title: 'Arquitetura');

      for (var book in books) {
        expect(book.title.toUpperCase(), contains('ARQUITETURA'));
      }
    });

    test('Get a list of books by category', () async {
      when(() => dio.get(any())).thenAnswer((_) async {
        return Response(
                data: categoryBooksMock, //  books of file books_json_mock.dart
                requestOptions: RequestOptions(path: ""))
            .data;
      });

      final books = await service.findBooksByCategory(category: 'Fiction');

      for (var book in books) {
        expect(book.categories.first, 'Fiction');
      }
    });
  });
}
