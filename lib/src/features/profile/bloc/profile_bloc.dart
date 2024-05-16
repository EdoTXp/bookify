import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:bookify/src/shared/services/storage_services/storage_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService _authService;
  final StorageServices _storageServices;

  ProfileBloc(
    this._authService,
    this._storageServices,
  ) : super(ProfileLoadingState()) {
    on<GotUserProfileEvent>(_gotUserProfileEvent);
    on<UserLoggedOutEvent>(_userLoggedOutEvent);
  }

  Future<void> _gotUserProfileEvent(
    GotUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());

      final userModel = await _authService.getUserModel();

      if (userModel == null) {
        emit(
          ProfileErrorState(
            errorMessage: 'Erro em buscar o usuário',
          ),
        );
        return;
      }

      emit(
        ProfileLoadedState(
          userModel: userModel,
        ),
      );
    } on AuthException catch (e) {
      emit(ProfileErrorState(
          errorMessage: 'Erro em buscar o usuário: ${e.message}'));
    } on Exception catch (e) {
      emit(
        ProfileErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }

  Future<void> _userLoggedOutEvent(
    UserLoggedOutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());

      final userLoggedOut = await _authService.signOut(
        signInType: event.userModel.signInType,
      );

      if (!userLoggedOut) {
        emit(
          ProfileErrorState(
            errorMessage: 'Erro em fazer o logout do usuário',
          ),
        );
        return;
      }

      final storageRemoved = await _storageServices.clearStorage();

      if (storageRemoved == 0) {
        emit(
          ProfileErrorState(
            errorMessage: 'Erro em limpar as configurações do usuário',
          ),
        );
        return;
      }

      emit(ProfileLogOutState());
    } on AuthException catch (e) {
      emit(ProfileErrorState(
          errorMessage: 'Erro em fazer o logout do usuário: ${e.message}'));
    } on Exception catch (e) {
      emit(
        ProfileErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
