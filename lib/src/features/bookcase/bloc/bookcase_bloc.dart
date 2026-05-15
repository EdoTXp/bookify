import 'package:bookify/src/core/dtos/bookcase_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/bookcase_service/bookcase_service.dart';

part 'bookcase_event.dart';
part 'bookcase_state.dart';

class BookcaseBloc extends Bloc<BookcaseEvent, BookcaseState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;

  BookcaseBloc(
    this._bookService,
    this._bookcaseService,
  ) : super(BookcaseLoadingState()) {
    on<GotAllBookcasesEvent>(_gotAllBookcasesEvent);
    on<FoundBookcaseByNameEvent>(_foundBookcaseByNameEvent);
    on<DeletedBookcasesEvent>(_deletedBookcasesEvent);
  }

  Future<void> _gotAllBookcasesEvent(
    GotAllBookcasesEvent event,
    Emitter<BookcaseState> emit,
  ) async {
    try {
      emit(BookcaseLoadingState());

      await _getAllBookcases(emit);
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _foundBookcaseByNameEvent(
    FoundBookcaseByNameEvent event,
    Emitter<BookcaseState> emit,
  ) async {
    try {
      emit(BookcaseLoadingState());

      await _findBookcaseByName(emit, event.searchQueryName);
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _deletedBookcasesEvent(
    DeletedBookcasesEvent event,
    Emitter<BookcaseState> emit,
  ) async {
    try {
      emit(BookcaseLoadingState());

      final selectedList = event.selectedList;

      for (var bookcaseDto in selectedList) {
        int bookcaseDeletedRow = await _bookcaseService.deleteBookcase(
          bookcaseId: bookcaseDto.bookcase.id!,
        );

        if (bookcaseDeletedRow == -1) {
          emit(
            BookcaseErrorState(
              errorCode: LocalDatabaseErrorCode.unknown,
              errorDescriptionMessage:
                  'Failed to delete the bookcase ${bookcaseDto.bookcase.name}.',
            ),
          );
          return;
        }
      }

      await _getAllBookcases(emit);
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookcaseErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _getAllBookcases(Emitter<BookcaseState> emit) async {
    final bookcases = await _bookcaseService.getAllBookcases();

    if (bookcases.isEmpty) {
      emit(BookcaseEmptyState());
      return;
    }

    await _mountBookcaseDto(bookcases, emit);
  }

  Future<void> _findBookcaseByName(
    Emitter<BookcaseState> emit,
    String name,
  ) async {
    final bookcases = await _bookcaseService.getBookcasesByName(name: name);

    if (bookcases.isEmpty) {
      emit(BookcaseNotFoundState());
      return;
    }

    await _mountBookcaseDto(bookcases, emit);
  }

  Future<void> _mountBookcaseDto(
    List<BookcaseModel> bookcases,
    Emitter<BookcaseState> emit,
  ) async {
    final List<BookcaseDto> bookcasesDto = [];

    for (BookcaseModel bookcase in bookcases) {
      if (bookcase.id == null) {
        emit(
          BookcaseErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Bookcase with null ID found.',
          ),
        );
        return;
      }

      String? bookId = await _bookcaseService.getBookIdForImagePreview(
        bookcaseId: bookcase.id!,
      );

      String? bookImagePreview;

      if (bookId != null) {
        bookImagePreview = await _bookService.getBookImage(id: bookId);
      }

      final bookcaseDto = BookcaseDto(
        bookcase: bookcase,
        bookImagePreview: bookImagePreview,
      );

      bookcasesDto.add(bookcaseDto);
    }

    emit(BookcaseLoadedState(bookcasesDto: bookcasesDto));
  }
}
