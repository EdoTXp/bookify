import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/errors/local_database_exception/local_database_exception.dart';
import 'package:bookify/src/core/errors/storage_exception/storage_exception.dart';
import 'package:bookify/src/domain/services/auth_service/auth_service.dart';
import 'package:bookify/src/domain/services/local_database_service/local_database_service.dart';
import 'package:bookify/src/domain/services/storage_services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final StorageService _storageService;
  final LocalDatabaseService _localDatabaseService;
  final AuthService _authService;

  DeleteAccountBloc({
    required StorageService storageService,
    required LocalDatabaseService localDatabaseService,
    required AuthService authService,
  }) : _storageService = storageService,
       _localDatabaseService = localDatabaseService,
       _authService = authService,
       super(DeleteAccountInitialState()) {
    on<DeletedAccountEvent>(_deletedAccountEvent);
  }

  Future<void> _deletedAccountEvent(
    DeletedAccountEvent event,
    Emitter<DeleteAccountState> emit,
  ) async {
    try {
      emit(DeleteAccountLoadingState());

      await _localDatabaseService.deleteDatabase();
      await _storageService.clearAllStorage();
      await _authService.deleteUserModel();

      emit(DeleteAccountLoadedState());
    } on LocalDatabaseException {
      emit(DeleteAccountErrorState());
    } on AuthException {
      emit(DeleteAccountErrorState());
    } on StorageException {
      emit(DeleteAccountErrorState());
    }
  }
}
