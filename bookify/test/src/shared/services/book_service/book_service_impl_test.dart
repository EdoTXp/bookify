import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository.dart';
import 'package:bookify/src/shared/services/book_service/book_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BooksRepositoryMock extends Mock implements BooksRepository {}

class AuthorsRepositoryMock extends Mock implements AuthorsRepository {}

class CategoriesRepositoryMock extends Mock implements CategoriesRepository {}

class BookAuthorsRepositoryMock extends Mock implements BookAuthorsRepository {}

class BookCategoriesRepositoryMock extends Mock
    implements BookCategoriesRepository {}

void main() {
  final booksRepository = BooksRepositoryMock();
  final authorsRepository = AuthorsRepositoryMock();
  final categoriesRepository = CategoriesRepositoryMock();
  final bookAuthorsRepository = BookAuthorsRepositoryMock();
  final bookCategoriesRepository = BookCategoriesRepositoryMock();

  final bookService = BookServiceImpl(
    booksRepository: booksRepository,
    authorsRepository: authorsRepository,
    categoriesRepository: categoriesRepository,
    bookAuthorsRepository: bookAuthorsRepository,
    bookCategoriesRepository: bookCategoriesRepository,
  );

  final bookModel = BookModel(
    id: '1',
    title: 'title',
    authors: [],
    publisher: 'publisher',
    description: 'description',
    categories: [],
    pageCount: 320,
    imageUrl: 'imageUrl',
    buyLink: 'buyLink',
    averageRating: 4.5,
    ratingsCount: 35,
    status: BookStatus.library,
  );

  final authorModel = AuthorModel(id: 1, name: 'authorModel');
  final categoryModel = CategoryModel(id: 1, name: 'categoryModel');
  final bookAuthorsRelationship = {'bookId': '1', 'authorId': 1};
  final bookCategoriesRelationship = {'bookId': '1', 'categoryId': 1};

  group('test normal CRUD of complete book without error ||', () {
    test('get all book', () async {
      when(
        () => booksRepository.getAll(),
      ).thenAnswer((_) async => [bookModel]);

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenAnswer((_) async => categoryModel);

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      final booksModel = await bookService.getAllBook();

      expect(booksModel[0].id, equals('1'));
      expect(booksModel[0].title, equals('title'));
      expect(booksModel[0].authors, equals([authorModel]));
      expect(booksModel[0].categories, equals([categoryModel]));
    });

    test('get book by title', () async {
      when(
        () => booksRepository.getBookByTitle(title: any(named: 'title')),
      ).thenAnswer((_) async => [bookModel]);

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenAnswer((_) async => categoryModel);

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      final booksModel = await bookService.getBookByTitle(title: 'title');

      expect(booksModel[0].id, equals('1'));
      expect(booksModel[0].title, equals('title'));
      expect(booksModel[0].authors, equals([authorModel]));
      expect(booksModel[0].categories, equals([categoryModel]));
    });

    test('get book by id', () async {
      // setUp all when

      //for book repository
      when(
        () => booksRepository.getBookById(id: any(named: 'id')),
      ).thenAnswer((_) async => bookModel);

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenAnswer((_) async => categoryModel);

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      final completeBookModel = await bookService.getBookById(id: '1');

      expect(completeBookModel.id, equals('1'));
      expect(completeBookModel.title, equals('title'));
      expect(completeBookModel.authors, equals([authorModel]));
      expect(completeBookModel.categories, equals([categoryModel]));
    });

    test('insert complete book', () async {
      // setUp all when
      final completeBookModel = bookModel
          .copyWith(authors: [authorModel], categories: [categoryModel]);

      //for book repository
      when(
        () => booksRepository.insert(bookModel: completeBookModel),
      ).thenAnswer((_) async => 1);

      //for author repository
      when(
        () => authorsRepository.getAuthorIdByColumnName(
            authorName: any(named: 'authorName')),
      ).thenAnswer((_) async => -1);

      when(
        () => authorsRepository.insert(authorModel: authorModel),
      ).thenAnswer((_) async => 1);

      // for category repository
      when(
        () => categoriesRepository.getCategoryIdByColumnName(
            categoryName: any(named: 'categoryName')),
      ).thenAnswer((_) async => 1);

      // for book authors repository
      when(
        () => bookAuthorsRepository.insert(
          bookId: any(named: 'bookId'),
          authorId: any(named: 'authorId'),
        ),
      ).thenAnswer((_) async => 1);

      // for book categories repository
      when(
        () => bookCategoriesRepository.insert(
          bookId: any(named: 'bookId'),
          categoryId: any(named: 'categoryId'),
        ),
      ).thenAnswer((_) async => 1);

      final isInserted =
          await bookService.insertCompleteBook(bookModel: completeBookModel);

      expect(isInserted, equals(1));
    });

    test('verify book is exist', () async {
      when(() => booksRepository.verifyBookIsAlreadyInserted(
            id: any(named: 'id'),
          )).thenAnswer((_) async => true);

      final bookIsInserted =
          await bookService.verifyBookIsAlreadyInserted(id: '1');
      expect(bookIsInserted, isTrue);
    });

    test('update status', () async {
      when(
        () => booksRepository.updateBookStatus(
            id: any(named: 'id'), status: BookStatus.reading),
      ).thenAnswer((_) async => 1);

      final bookRowUpdated =
          await bookService.updateStatus(id: '1', status: BookStatus.reading);
      expect(bookRowUpdated, equals(1));
    });

    test('get book Image', () async {
      when(
        () => booksRepository.getBookImageById(id: any(named: 'id')),
      ).thenAnswer((_) async => 'imageUrl');

      final bookImageUrl = await bookService.getBookImage(id: '1');
      expect(bookImageUrl, equals('imageUrl'));
    });

    test('delete book', () async {
      when(() => booksRepository.deleteBookById(id: any(named: 'id')))
          .thenAnswer((_) async => 1);

      final deleteBookRow = await bookService.deleteBook(id: '1');

      expect(deleteBookRow, equals(1));
    });
  });

  group('test normal CRUD of complete book with error ||', () {
    test('get all book', () async {
      when(
        () => booksRepository.getAll(),
      ).thenThrow(LocalDatabaseException('Error on database'));

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenAnswer((_) async => categoryModel);

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      expect(
        () async => await bookService.getAllBook(),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book by name', () async {
      when(
        () => booksRepository.getBookByTitle(title: any(named: 'title')),
      ).thenThrow(LocalDatabaseException('Error on database'));

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenAnswer((_) async => categoryModel);

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      expect(
        () async => await bookService.getBookByTitle(title: 'title'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book by id', () async {
      // setUp all when

      //for book repository
      when(
        () => booksRepository.getBookById(id: any(named: 'id')),
      ).thenAnswer((_) async => bookModel);

      //for author repository
      when(() => authorsRepository.getAuthorById(id: any(named: 'id')))
          .thenAnswer((_) async => authorModel);

      // for category repository
      when(() => categoriesRepository.getCategoryById(id: any(named: 'id')))
          .thenThrow(LocalDatabaseException('Error on database'));

      // for book authors repository
      when(() => bookAuthorsRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookAuthorsRelationship]);

      // for book categories repository
      when(() => bookCategoriesRepository.getRelationshipsById(
              bookId: any(named: 'bookId')))
          .thenAnswer((_) async => [bookCategoriesRelationship]);

      expect(
        () async => await bookService.getBookById(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('insert complete book', () async {
      // setUp all when
      final completeBookModel = bookModel
          .copyWith(authors: [authorModel], categories: [categoryModel]);

      //for book repository
      when(
        () => booksRepository.insert(bookModel: completeBookModel),
      ).thenAnswer((_) async => 1);

      //for author repository
      when(
        () => authorsRepository.getAuthorIdByColumnName(
            authorName: any(named: 'authorName')),
      ).thenAnswer((_) async => -1);

      when(
        () => authorsRepository.insert(authorModel: authorModel),
      ).thenThrow(LocalDatabaseException('Error on database'));

      // for category repository
      when(
        () => categoriesRepository.getCategoryIdByColumnName(
            categoryName: any(named: 'categoryName')),
      ).thenAnswer((_) async => 1);

      // for book authors repository
      when(
        () => bookAuthorsRepository.insert(
          bookId: any(named: 'bookId'),
          authorId: any(named: 'authorId'),
        ),
      ).thenAnswer((_) async => 1);

      // for book categories repository
      when(
        () => bookCategoriesRepository.insert(
          bookId: any(named: 'bookId'),
          categoryId: any(named: 'categoryId'),
        ),
      ).thenAnswer((_) async => 1);

      expect(
        () async =>
            await bookService.insertCompleteBook(bookModel: completeBookModel),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('verify book is exist', () async {
      when(() => booksRepository.verifyBookIsAlreadyInserted(
            id: any(named: 'id'),
          )).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async => await bookService.verifyBookIsAlreadyInserted(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('update status', () async {
      when(
        () => booksRepository.updateBookStatus(
            id: any(named: 'id'), status: BookStatus.reading),
      ).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async =>
            await bookService.updateStatus(id: '1', status: BookStatus.reading),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('get book Image', () async {
      when(
        () => booksRepository.getBookImageById(id: any(named: 'id')),
      ).thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async => await bookService.getBookImage(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });

    test('delete book', () async {
      when(() => booksRepository.deleteBookById(id: any(named: 'id')))
          .thenThrow(LocalDatabaseException('Error on database'));

      expect(
        () async => await bookService.deleteBook(id: '1'),
        throwsA((Exception e) =>
            e is LocalDatabaseException && e.message == 'Error on database'),
      );
    });
  });
}
