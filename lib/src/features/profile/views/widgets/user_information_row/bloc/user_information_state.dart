part of 'user_information_bloc.dart';

sealed class UserInformationState {}

final class UserInformationLoadingState extends UserInformationState {}

final class UserInformationLoadedState extends UserInformationState {
  final int bookcasesCount;
  final int bookCount;
  final int loansCount;
  final int readingsCount;

  UserInformationLoadedState({
    required this.bookcasesCount,
    required this.bookCount,
    required this.loansCount,
    required this.readingsCount,
  });
}

final class UserInformationErrorState extends UserInformationState {
  final LocalDatabaseErrorCode errorCode;
  final String? errorDescriptionMessage;

  UserInformationErrorState({
    required this.errorCode,
    required this.errorDescriptionMessage,
  });
}
