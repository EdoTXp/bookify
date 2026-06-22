import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/domain/services/book_service/book_service.dart';
import 'package:bookify/src/domain/services/bookcase_service/bookcase_service.dart';
import 'package:bookify/src/domain/services/loan_services/loan_service.dart';
import 'package:bookify/src/domain/services/reading_services/reading_service.dart';
import 'package:bookify/src/core/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_information_event.dart';
part 'user_information_state.dart';

class UserInformationBloc
    extends Bloc<UserInformationEvent, UserInformationState> {
  final BookService _bookService;
  final BookcaseService _bookcaseService;
  final LoanService _loanService;
  final ReadingService _readingService;

  UserInformationBloc(
    this._bookService,
    this._bookcaseService,
    this._loanService,
    this._readingService,
  ) : super(UserInformationLoadingState()) {
    on<GotUserInformationEvent>(_gotUserInformationEvent);
  }

  Future<void> _gotUserInformationEvent(
    GotUserInformationEvent event,
    Emitter<UserInformationState> emit,
  ) async {
    try {
      emit(UserInformationLoadingState());

      final int bookCount = await _bookService.countBooks();
      final int bookcasesCount = await _bookcaseService.countBookcases();
      final int loansCount = await _loanService.countLoans();
      final int readingsCount = await _readingService.countReadings();

      emit(
        UserInformationLoadedState(
          bookcasesCount: bookcasesCount,
          bookCount: bookCount,
          loansCount: loansCount,
          readingsCount: readingsCount,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(
        UserInformationErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        UserInformationErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
