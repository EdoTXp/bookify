import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/domain/models/bookcase_model.dart';
import 'package:bookify/src/domain/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookcase_insertion_event.dart';
part 'bookcase_insertion_state.dart';

class BookcaseInsertionBloc
    extends Bloc<BookcaseInsertionEvent, BookcaseInsertionState> {
  final BookcaseService _bookcaseService;

  BookcaseInsertionBloc(
    this._bookcaseService,
  ) : super(BookcaseInsertionLoadingState()) {
    on<InsertedBookcaseEvent>(_insertedBookcaseEvent);
    on<UpdatedBookcaseEvent>(_updatedBookcaseEvent);
  }

  Future<void> _insertedBookcaseEvent(
    InsertedBookcaseEvent event,
    Emitter<BookcaseInsertionState> emit,
  ) async {
    try {
      emit(BookcaseInsertionLoadingState());

      final bookcaseModel = BookcaseModel(
        name: event.name,
        description: event.description,
        color: event.color,
      );

      final newBookcaseId = await _bookcaseService.insertBookcase(
        bookcaseModel: bookcaseModel,
      );

      if (newBookcaseId == 0) {
        emit(
          BookcaseInsertionErrorState(
            errorCode: LocalDatabaseErrorCode.operationFailed,
            errorDescriptionMessage:
                'An error occurred while inserting the bookcase',
          ),
        );
        return;
      }

      emit(
        BookcaseInsertionInsertedState(
          reason: BookcaseInsertionSuccessReason.inserted,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseInsertionErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookcaseInsertionErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _updatedBookcaseEvent(
    UpdatedBookcaseEvent event,
    Emitter<BookcaseInsertionState> emit,
  ) async {
    try {
      emit(BookcaseInsertionLoadingState());

      final bookcaseModel = BookcaseModel(
        id: event.id,
        name: event.name,
        description: event.description,
        color: event.color,
      );

      final bookcaseRowUpdated = await _bookcaseService.updateBookcase(
        bookcaseModel: bookcaseModel,
      );

      if (bookcaseRowUpdated < 1) {
        emit(
          BookcaseInsertionErrorState(
            errorCode: LocalDatabaseErrorCode.operationFailed,
            errorDescriptionMessage:
                'An error occurred while updating the bookcase',
          ),
        );
        return;
      }

      emit(
        BookcaseInsertionInsertedState(
          reason: BookcaseInsertionSuccessReason.updated,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(
        BookcaseInsertionErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        BookcaseInsertionErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
