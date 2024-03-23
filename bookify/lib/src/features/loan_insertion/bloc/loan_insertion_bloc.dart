import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/models/loan_model.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/custom_notification.dart';
import 'package:bookify/src/shared/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/shared/services/book_service/book_service.dart';
import 'package:bookify/src/shared/services/loan_services/loan_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loan_insertion_event.dart';
part 'loan_insertion_state.dart';

class LoanInsertionBloc extends Bloc<LoanInsertionEvent, LoanInsertionState> {
  final BookService _bookService;
  final LoanService _loanService;
  final NotificationsService _notificationsService;

  LoanInsertionBloc(
    this._bookService,
    this._loanService,
    this._notificationsService,
  ) : super(LoanInsertionLoadingState()) {
    on<InsertedLoanInsertionEvent>(_insertedLoanEvent);
    on<UpdatedLoanInsertionEvent>(_updatedLoanEvent);
  }

  Future<void> _insertedLoanEvent(
    InsertedLoanInsertionEvent event,
    Emitter<LoanInsertionState> emit,
  ) async {
    try {
      emit(LoanInsertionLoadingState());

      final bookUpdatedStatus = await _bookService.updateStatus(
        id: event.bookId,
        status: BookStatus.loaned,
      );

      if (bookUpdatedStatus == 0) {
        emit(
          LoanInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao adicionar o livro ao empréstimo',
          ),
        );
        return;
      }

      final loanModel = LoanModel(
        observation: event.observation,
        loanDate: event.loanDate,
        devolutionDate: event.devolutionDate,
        bookId: event.bookId,
        idContact: event.idContact,
      );

      final loanId = await _loanService.insert(loanModel: loanModel);

      if (loanId == 0) {
        emit(
          LoanInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao inserir o empréstimo',
          ),
        );
        return;
      }

      await _notificationsService.scheduleNotification(
        notification: CustomNotification(
          id: loanId,
          title: 'Empréstimo do livro: ${event.bookTitle}',
          body:
              'Chegou o dia de receber o livro: ${event.bookTitle}, emprestado para ${event.contactName}',
          channelId: 'loan_channel_id',
          channelName: 'loan_channel',
          scheduledDate: event.devolutionDate,
        ),
      );

      emit(
        LoanInsertionInsertedState(
          loanId: loanId,
          loanInsertionMessage: 'Empréstimo inserido com sucesso',
          devolutionDate: event.devolutionDate,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(LoanInsertionErrorState(
          errorMessage: 'Ocorreu um erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(LoanInsertionErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e'));
    }
  }

  Future<void> _updatedLoanEvent(
    UpdatedLoanInsertionEvent event,
    Emitter<LoanInsertionState> emit,
  ) async {
    try {
      emit(LoanInsertionLoadingState());

      final loanModel = LoanModel(
        id: event.id,
        observation: event.observation,
        loanDate: event.loanDate,
        devolutionDate: event.devolutionDate,
        bookId: event.bookId,
        idContact: event.idContact,
      );

      final loanId = await _loanService.update(loanModel: loanModel);

      if (loanId < 1) {
        emit(
          LoanInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao atualizar o empréstimo',
          ),
        );
        return;
      }

      await _notificationsService.cancelNotificationById(id: loanId);
      
      await _notificationsService.scheduleNotification(
        notification: CustomNotification(
          id: loanId,
          title: 'Empréstimo do livro: ${event.bookTitle}',
          body:
              'Chegou o dia de receber o livro: ${event.bookTitle}, emprestado para ${event.contactName}',
          channelId: 'loan_channel_id',
          channelName: 'loan_channel',
          scheduledDate: event.devolutionDate,
        ),
      );

      emit(
        LoanInsertionInsertedState(
          loanId: loanId,
          loanInsertionMessage: 'Empréstimo atualizado com sucesso',
          devolutionDate: event.devolutionDate,
        ),
      );
    } on LocalDatabaseException catch (e) {
      emit(LoanInsertionErrorState(
          errorMessage: 'Ocorreu um erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(LoanInsertionErrorState(
          errorMessage: 'Ocorreu um erro não esperado: $e'));
    }
  }
}
