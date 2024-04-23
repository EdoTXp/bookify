import 'package:bookify/src/shared/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/shared/helpers/date_time_format/date_time_format_extension.dart';
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

      if (bookUpdatedStatus < 1) {
        emit(
          LoanInsertionErrorState(
            errorMessage:
                'Ocorreu um erro ao adicionar o livro ao empréstimo. Verifique se o livro já não foi emprestado ou em lista de leitura',
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

      if (loanId < 1) {
        emit(
          LoanInsertionErrorState(
            errorMessage: 'Ocorreu um erro ao criar o empréstimo',
          ),
        );
        return;
      }

      await _createNotification(
        loanId,
        event.contactName,
        event.bookTitle,
        event.loanDate,
        event.devolutionDate,
      );

      emit(
        LoanInsertionInsertedState(
          loanInsertionMessage: 'Empréstimo inserido com sucesso',
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

  Future<void> _createNotification(
    int loanId,
    String contactName,
    String bookTitle,
    DateTime loanDate,
    DateTime devolutionDate,
  ) async {
    final customNotification = CustomNotification(
      id: loanId,
      title: 'Ei, seu livro tá voltando!',
      body:
          'Olá! Só passando pra lembrar que tá na hora de ${contactName.toUpperCase()} devolver o ${bookTitle.toUpperCase()} que você emprestou no dia ${loanDate.toFormattedDate()}.',
      notificationChannel: NotificationChannel.loanChannel,
      scheduledDate: devolutionDate,
      payload: '/loan_detail',
    );

    await _notificationsService.scheduleNotification(customNotification);
  }
}
