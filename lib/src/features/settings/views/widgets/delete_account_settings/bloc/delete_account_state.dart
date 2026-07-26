part of 'delete_account_bloc.dart';

@immutable
sealed class DeleteAccountState {}

final class DeleteAccountInitialState extends DeleteAccountState {}

final class DeleteAccountLoadingState extends DeleteAccountState {}

final class DeleteAccountLoadedState extends DeleteAccountState {}

final class DeleteAccountErrorState extends DeleteAccountState {}
