part of 'contacts_picker_bloc.dart';

sealed class ContactsPickerState {}

final class ContactsPickerLoadingState extends ContactsPickerState {}

final class ContactsPickerEmptyState extends ContactsPickerState {}

final class ContactsPickerLoadedState extends ContactsPickerState {
  final List<ContactModel> contacts;

  ContactsPickerLoadedState({
    required this.contacts,
  });
}

final class ContactsPickerErrorState extends ContactsPickerState {
  final PlatformErrorCode errorCode;
  final String? errorDescriptionMessage;

  ContactsPickerErrorState({
    required this.errorCode,
    this.errorDescriptionMessage,
  });
}
