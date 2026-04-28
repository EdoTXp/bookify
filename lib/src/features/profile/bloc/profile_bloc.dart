import 'package:bookify/src/core/enums/auth_error_code.dart';
import 'package:bookify/src/core/errors/auth_exception/auth_exception.dart';
import 'package:bookify/src/core/models/user_model.dart';
import 'package:bookify/src/core/services/auth_service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService _authService;

  ProfileBloc(
    this._authService,
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
            errorCode: AuthErrorCode.internalError,
            errorDescriptionMessage:
                'Failed to save user data. Please try again.',
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
      emit(
        ProfileErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ProfileErrorState(
          errorCode: AuthErrorCode.internalError,
          errorDescriptionMessage: e.toString(),
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
            errorCode: AuthErrorCode.internalError,
            errorDescriptionMessage: 'Failed to logout',
          ),
        );
        return;
      }

      emit(ProfileLogOutState());
    } on AuthException catch (e) {
      emit(
        ProfileErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ProfileErrorState(
          errorCode: AuthErrorCode.internalError,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
