import 'package:bookify/src/core/dtos/loan_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/contacts_service/contacts_service.dart';
import 'package:bookify/src/core/services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loan_detail_event.dart';
part 'loan_detail_state.dart';

class LoanDetailBloc extends Bloc<LoanDetailEvent, LoanDetailState> {
  final LoanService _loanService;
  final BookService _bookService;
  final ContactsService _contactsService;
  final NotificationsService _notificationsService;

  LoanDetailBloc(
    this._loanService,
    this._bookService,
    this._contactsService,
    this._notificationsService,
  ) : super(LoanDetailLoadingState()) {
    on<GotLoanDetailEvent>(_gotLoanDetailEvent);
    on<FinishedLoanDetailEvent>(_finishedLoanDetailEvent);
  }

  Future<void> _gotLoanDetailEvent(
    GotLoanDetailEvent event,
    Emitter<LoanDetailState> emit,
  ) async {
    try {
      emit(LoanDetailLoadingState());

      final loan = await _loanService.getById(loanId: event.id);
      final book = await _bookService.getBookById(id: loan.bookId);
      final contact = await _contactsService.getContactById(id: loan.idContact);

      final loanDto = LoanDto(
        loanModel: loan,
        contactModel: contact,
        bookImagePreview: book.imageUrl,
        bookTitlePreview: book.title,
      );

      emit(
        LoanDetailLoadedState(
          loanDto: loanDto,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _finishedLoanDetailEvent(
    FinishedLoanDetailEvent event,
    Emitter<LoanDetailState> emit,
  ) async {
    try {
      emit(LoanDetailLoadingState());

      await _notificationsService.cancelNotificationById(id: event.loanId);
      final bookStatusUpdated = await _bookService.updateStatus(
        id: event.bookId,
        status: BookStatus.library,
      );

      if (bookStatusUpdated != 1) {
        emit(
          LoanDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Impossible to remove the book status',
          ),
        );
        return;
      }

      final loanRemovedRow = await _loanService.delete(loanId: event.loanId);

      if (loanRemovedRow != 1) {
        emit(
          LoanDetailErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage: 'Impossible to remove the loan',
          ),
        );
        return;
      }

      emit(LoanDetailFinishedState());
    } on LocalDatabaseException catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on PlatformException catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } catch (e) {
      emit(
        LoanDetailErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
