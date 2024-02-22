import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/author_model.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/category_model.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';

typedef BookComponents = (List<AuthorModel>, List<CategoryModel>);

class BookServiceImpl implements BookService {
  final BooksRepository _booksRepository;
  final AuthorsRepository _authorsRepository;
  final CategoriesRepository _categoriesRepository;
  final BookAuthorsRepository _bookAuthorsRepository;
  final BookCategoriesRepository _bookCategoriesRepository;

  BookServiceImpl({
    required BooksRepository booksRepository,
    required AuthorsRepository authorsRepository,
    required CategoriesRepository categoriesRepository,
    required BookAuthorsRepository bookAuthorsRepository,
    required BookCategoriesRepository bookCategoriesRepository,
  })  : _booksRepository = booksRepository,
        _authorsRepository = authorsRepository,
        _categoriesRepository = categoriesRepository,
        _bookAuthorsRepository = bookAuthorsRepository,
        _bookCategoriesRepository = bookCategoriesRepository;

  @override
  Future<List<BookModel>> getAllBook() async {
    try {
      final booksModel = await _booksRepository.getAll();

      for (var index = 0; index < booksModel.length; index++) {
        final (authors, categories) =
            await _getBookComponents(booksModel[index].id);
        booksModel[index] = booksModel[index].copyWith(
          authors: authors,
          categories: categories,
        );
      }

      return booksModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<BookModel> getBookById({required String id}) async {
    try {
      var bookModel = await _booksRepository.getBookById(id: id);

      final (authors, categories) = await _getBookComponents(id);

      bookModel = bookModel.copyWith(
        authors: authors,
        categories: categories,
      );

      return bookModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<BookModel>> getBookByTitle({required String title}) async {
    try {
      final booksModel = await _booksRepository.getBookByTitle(title: title);

      for (var index = 0; index < booksModel.length; index++) {
        final (authors, categories) =
            await _getBookComponents(booksModel[index].id);
        booksModel[index] = booksModel[index].copyWith(
          authors: authors,
          categories: categories,
        );
      }

      return booksModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insertCompleteBook({required BookModel bookModel}) async {
    try {
      await _booksRepository.insert(bookModel: bookModel);

      final authors = bookModel.authors;

      for (var author in authors) {
        int authorId = await _authorsRepository.getAuthorIdByColumnName(
          authorName: author.name,
        );

        if (authorId == -1) {
          authorId = await _authorsRepository.insert(authorModel: author);
        }

        await _bookAuthorsRepository.insert(
          bookId: bookModel.id,
          authorId: authorId,
        );
      }

      final categories = bookModel.categories;

      for (var category in categories) {
        int categoryId = await _categoriesRepository.getCategoryIdByColumnName(
          categoryName: category.name,
        );

        if (categoryId == -1) {
          categoryId =
              await _categoriesRepository.insert(categoryModel: category);
        }

        await _bookCategoriesRepository.insert(
          bookId: bookModel.id,
          categoryId: categoryId,
        );
      }

      return 1;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<bool> verifyBookIsAlreadyInserted({required String id}) async {
    try {
      final isInserted =
          await _booksRepository.verifyBookIsAlreadyInserted(id: id);
      return isInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> updateStatus({
    required String id,
    required BookStatus status,
  }) async {
    try {
      final bookUpdated =
          await _booksRepository.updateBookStatus(id: id, status: status);
      return bookUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<String> getBookImage({required String id}) async {
    try {
      final bookImage = await _booksRepository.getBookImageById(id: id);
      return bookImage;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteBook({required String id}) async {
    try {
      final deletedRow = await _booksRepository.deleteBookById(id: id);
      return deletedRow;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  Future<BookComponents> _getBookComponents(String bookId) async {
    final bookAuthorsRelationShip =
        await _bookAuthorsRepository.getRelationshipsById(bookId: bookId);

    final authorsId = bookAuthorsRelationShip
        .map((relationship) => relationship['authorId'] as int)
        .toList();

    final authors = <AuthorModel>[];
    for (int id in authorsId) {
      final author = await _authorsRepository.getAuthorById(id: id);
      authors.add(author);
    }

    final bookCategoriesRelationShip =
        await _bookCategoriesRepository.getRelationshipsById(bookId: bookId);

    final categoriesId = bookCategoriesRelationShip
        .map((relationship) => relationship['categoryId'] as int)
        .toList();

    final categories = <CategoryModel>[];
    for (int id in categoriesId) {
      final category = await _categoriesRepository.getCategoryById(id: id);
      categories.add(category);
    }

    return (authors, categories);
  }
}
