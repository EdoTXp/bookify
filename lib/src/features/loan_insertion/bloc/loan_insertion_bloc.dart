import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/book_model.dart';
import 'package:bookify/src/core/models/loan_model.dart';
import 'package:bookify/src/core/models/custom_notification_model.dart';
import 'package:bookify/src/core/services/app_services/notifications_service/notifications_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:bookify/src/shared/enums/local_database_error_code.dart';
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
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage:
                'An error occurred while updating the book status to loaned. Verify is already loaned or if the book exists.',
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

      final loanId = await _loanService.insert(
        loanModel: loanModel,
      );

      if (loanId < 1) {
        emit(
          LoanInsertionErrorState(
            errorCode: LocalDatabaseErrorCode.unknown,
            errorDescriptionMessage:
                'An error occurred while creating the loan',
          ),
        );
        return;
      }

      await _createNotification(
        loanId,
        event.devolutionDate,
        event.notificationTitle,
        event.notificationBody,
      );

      emit(LoanInsertionInsertedState());
    } on LocalDatabaseException catch (e) {
      emit(
        LoanInsertionErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        LoanInsertionErrorState(
          errorCode: LocalDatabaseErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _createNotification(
    int loanId,
    DateTime devolutionDate,
    String title,
    String body,
  ) async {
    final customNotification = CustomNotificationModel(
      id: loanId,
      title: title,
      body: body,
      notificationChannel: NotificationChannel.loanChannel,
      scheduledDate: devolutionDate,
      payload: '/loan_detail',
    );

    await _notificationsService.scheduleNotification(customNotification);
  }
}
