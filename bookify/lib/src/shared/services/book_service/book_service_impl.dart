import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/repositories/author_repository/authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_authors_repository/book_authors_repository.dart';
import 'package:bookify/src/shared/repositories/book_categories_repository/book_categories_repository.dart';
import 'package:bookify/src/shared/repositories/books_repository/books_repository.dart';
import 'package:bookify/src/shared/repositories/category_repository/categories_repository.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';

class BookServiceImpl implements BookService {
  final BooksRepository _booksRepository;
  final AuthorsRepository _authorsRepository;
  final CategoriesRepository _categoryRepository;
  final BookAuthorsRepository _bookAuthorsRepository;
  final BookCategoriesRepository _bookCategoriesRepository;

  BookServiceImpl({
    required BooksRepository booksRepository,
    required AuthorsRepository authorsRepository,
    required CategoriesRepository categoryRepository,
    required BookAuthorsRepository bookAuthorsRepository,
    required BookCategoriesRepository bookCategoriesRepository,
  })  : _booksRepository = booksRepository,
        _authorsRepository = authorsRepository,
        _categoryRepository = categoryRepository,
        _bookAuthorsRepository = bookAuthorsRepository,
        _bookCategoriesRepository = bookCategoriesRepository;

  @override
  Future<void> insertCompleteBook({required BookModel bookModel}) async {
    await _booksRepository.insert(bookModel: bookModel);

    for (var author in bookModel.authors) {
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

    for (var category in bookModel.categories) {
      int categoryId = await _categoryRepository.getCategoryIdByColumnName(
        categoryName: category.name,
      );

      if (categoryId == -1) {
        categoryId = await _categoryRepository.insert(categoryModel: category);
      }

      await _bookCategoriesRepository.insert(
        bookId: bookModel.id,
        categoryId: categoryId,
      );
    }
  }

  @override
  Future<bool> verifyBookIsAlreadyInserted({required String id}) async {
    final isInserted =
        await _booksRepository.verifyBookIsAlreadyInserted(id: id);
    return isInserted;
  }

  @override
  Future<int> deleteBook({required String id}) async {
    final deletedRow = await _booksRepository.deleteBookById(id: id);
    return deletedRow;
  }
}
