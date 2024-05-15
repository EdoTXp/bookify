import 'package:bookify/src/shared/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/shared/models/user_model.dart';
import 'package:bookify/src/shared/services/auth_service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService _authService;

  ProfileBloc(this._authService) : super(ProfileLoadingState()) {
    on<GotUserProfileEvent>(_gotUserProfile);
  }

  Future<void> _gotUserProfile(
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
}
