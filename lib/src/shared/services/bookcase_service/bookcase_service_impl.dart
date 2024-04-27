import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/bookcase_model.dart';
import 'package:bookify/src/shared/repositories/book_on_case_repository/book_on_case_repository.dart';
import 'package:bookify/src/shared/repositories/bookcase_repository/bookcase_repository.dart';
import 'package:bookify/src/shared/services/bookcase_service/bookcase_service.dart';

class BookcaseServiceImpl implements BookcaseService {
  final BookcaseRepository _bookcaseRepository;
  final BookOnCaseRepository _bookOnCaseRepository;

  BookcaseServiceImpl({
    required BookcaseRepository bookcaseRepository,
    required BookOnCaseRepository bookOnCaseRepository,
  })  : _bookcaseRepository = bookcaseRepository,
        _bookOnCaseRepository = bookOnCaseRepository;

  @override
  Future<List<BookcaseModel>> getAllBookcases() async {
    try {
      final bookcasesModel = await _bookcaseRepository.getAll();
      return bookcasesModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<BookcaseModel>> getBookcasesByName({required String name}) async {
    try {
      final bookcasesModel = await _bookcaseRepository.getBookcasesByName(
        name: name,
      );
      return bookcasesModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookcaseRelationships(
      {required int bookcaseId}) async {
    try {
      final bookcasesRelationships = await _bookOnCaseRepository
          .getBooksOnCaseRelationship(bookcaseId: bookcaseId);
      return bookcasesRelationships;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteBookcaseRelationship(
      {required int bookcaseId, required String bookId}) async {
    try {
      final bookcaseRelationshipRowDeleted =
          await _bookOnCaseRepository.deleteBookcaseRelationship(
        bookcaseId: bookcaseId,
        bookId: bookId,
      );
      return bookcaseRelationshipRowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<String?> getBookIdForImagePreview({required int bookcaseId}) async {
    try {
      final bookImage = await _bookOnCaseRepository.getBookIdForImagePreview(
        bookcaseId: bookcaseId,
      );
      return bookImage;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<BookcaseModel> getBookcaseById({required int bookcaseId}) async {
    try {
      final bookcaseModel =
          await _bookcaseRepository.getById(bookcaseId: bookcaseId);
      return bookcaseModel;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insertBookcase({required BookcaseModel bookcaseModel}) async {
    try {
      final newBookcaseId =
          _bookcaseRepository.insert(bookcaseModel: bookcaseModel);
      return newBookcaseId;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> insertBookcaseRelationship({
    required int bookcaseId,
    required String bookId,
  }) async {
    try {
      final newRowInserted = await _bookOnCaseRepository.insert(
        bookcaseId: bookcaseId,
        bookId: bookId,
      );
      return newRowInserted;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> countBookcasesByBook({required String bookId}) async {
    try {
      final bookcasesCount = await _bookOnCaseRepository.countBookcasesByBook(
        bookId: bookId,
      );

      return bookcasesCount;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> updateBookcase({required BookcaseModel bookcaseModel}) async {
    try {
      final rowUpdated = await _bookcaseRepository.update(
        bookcaseModel: bookcaseModel,
      );

      return rowUpdated;
    } on LocalDatabaseException {
      rethrow;
    }
  }

  @override
  Future<int> deleteBookcase({required int bookcaseId}) async {
    try {
      final rowDeleted = await _bookcaseRepository.delete(
        bookcaseId: bookcaseId,
      );

      return rowDeleted;
    } on LocalDatabaseException {
      rethrow;
    }
  }
}
