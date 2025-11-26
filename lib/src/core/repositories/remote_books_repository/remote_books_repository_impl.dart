import 'dart:io';

import 'package:bookify/src/core/data_sources/remote_books_data_source/remote_books_data_source.dart';
import 'package:bookify/src/core/errors/book_exception/book_exception.dart';

import 'package:bookify/src/core/models/book_model.dart';

import 'remote_books_repository.dart';

class RemoteBooksRepositoryImpl implements RemoteBooksRepository {
  final RemoteBooksDataSource _booksDataSource;

  RemoteBooksRepositoryImpl(this._booksDataSource);

  @override
  Future<List<BookModel>> findBooksByAuthor({required String author}) async {
    try {
      final books = await _booksDataSource.findBooksByAuthor(author: author);
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> findBooksByIsbn({required String isbn}) async {
    try {
      final books = await _booksDataSource.findBooksByIsbn(isbn: isbn);
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> findBooksByPublisher(
      {required String publisher}) async {
    try {
      final books =
          await _booksDataSource.findBooksByPublisher(publisher: publisher);
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> findBooksByCategory(
      {required String category}) async {
    try {
      final books =
          await _booksDataSource.findBooksByCategory(category: category);
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> findBooksByTitle({required String title}) async {
    try {
      final books = await _booksDataSource.findBooksByTitle(title: title);
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getAllBooks() async {
    try {
      final books = await _booksDataSource.getAllBooks();
      return books;
    } on BookNotFoundException {
      rethrow;
    } on BookException {
      rethrow;
    } on SocketException {
      rethrow;
    }
  }
}
