import 'package:bookify/src/core/dtos/loan_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
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
        contactDto: contact,
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
        LoanDetailErrorState(errorMessage: 'Erro no database: ${e.message}'),
      );
    } catch (e) {
      emit(
        LoanDetailErrorState(errorMessage: 'Ocorreu um erro não esperado: $e'),
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
          id: event.bookId, status: BookStatus.library);

      if (bookStatusUpdated != 1) {
        emit(
          LoanDetailErrorState(
              errorMessage: 'Impossível remover o livro do empréstimo'),
        );
        return;
      }

      final loanRemovedRow =
          await _loanService.delete(loanId: event.loanId);

      if (loanRemovedRow != 1) {
        emit(
          LoanDetailErrorState(errorMessage: 'Impossível remover o empréstimo'),
        );
        return;
      }

      emit(LoanDetailFinishedState());
    } on LocalDatabaseException catch (e) {
      emit(
        LoanDetailErrorState(errorMessage: 'Erro no database: ${e.message}'),
      );
    } catch (e) {
      emit(
        LoanDetailErrorState(errorMessage: 'Ocorreu um erro não esperado: $e'),
      );
    }
  }
}
