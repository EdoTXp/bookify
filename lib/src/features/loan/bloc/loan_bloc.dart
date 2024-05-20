import 'package:bookify/src/core/dtos/loan_dto.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/models/loan_model.dart';
import 'package:bookify/src/core/services/app_services/contacts_service/contacts_service.dart';
import 'package:bookify/src/core/services/book_service/book_service.dart';
import 'package:bookify/src/core/services/loan_services/loan_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'loan_event.dart';
part 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final BookService _bookService;
  final LoanService _loanService;
  final ContactsService _contactsService;

  LoanBloc(
    this._bookService,
    this._loanService,
    this._contactsService,
  ) : super(LoanLoadingState()) {
    on<GotAllLoansEvent>(_gotAllLoansEvent);
    on<FindedLoanByBookTitleEvent>(_findedLoanByBookNameEvent);
  }

  Future<void> _gotAllLoansEvent(
    GotAllLoansEvent event,
    Emitter<LoanState> emit,
  ) async {
    try {
      emit(LoanLoadingState());

      final loans = await _loanService.getAll();

      if (loans.isEmpty) {
        emit(LoanEmptyState());
        return;
      }

      await _mountLoanDto(loans, emit);
    } on LocalDatabaseException catch (e) {
      emit(LoanErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(LoanErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _findedLoanByBookNameEvent(
    FindedLoanByBookTitleEvent event,
    Emitter<LoanState> emit,
  ) async {
    try {
      emit(LoanLoadingState());

      final loans = await _loanService.getLoansByBookTitle(
        title: event.searchQueryName,
      );

      if (loans.isEmpty) {
        emit(LoanNotFoundState());
        return;
      }

      await _mountLoanDto(loans, emit);
    } on LocalDatabaseException catch (e) {
      emit(LoanErrorState(errorMessage: 'Erro no database: ${e.message}'));
    } on Exception catch (e) {
      emit(LoanErrorState(errorMessage: 'Erro inesperado: $e'));
    }
  }

  Future<void> _mountLoanDto(
    List<LoanModel> loans,
    Emitter<LoanState> emit,
  ) async {
    final List<LoanDto> loansDto = [];

    for (LoanModel loan in loans) {
      if (loan.id == null) {
        emit(
          LoanErrorState(errorMessage: 'Erro inesperado: ${loan.id}'),
        );
        return;
      }

      final book = await _bookService.getBookById(
        id: loan.bookId,
      );

      final contact = await _contactsService.getContactById(
        id: loan.idContact,
      );

      final loanDto = LoanDto(
        loanModel: loan,
        bookImagePreview: book.imageUrl,
        bookTitlePreview: book.title,
        contactDto: contact,
      );

      loansDto.add(loanDto);
    }

    emit(LoanLoadedState(loansDto: loansDto));
  }
}
