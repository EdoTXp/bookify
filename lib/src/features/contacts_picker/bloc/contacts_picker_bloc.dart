import 'package:bookify/src/core/models/contact_model.dart';
import 'package:bookify/src/core/services/app_services/contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contacts_picker_event.dart';
part 'contacts_picker_state.dart';

class ContactsPickerBloc
    extends Bloc<ContactsPickerEvent, ContactsPickerState> {
  final ContactsService _contactsService;

  ContactsPickerBloc(this._contactsService)
      : super(ContactsPickerLoadingState()) {
    on<GotContactsPickerEvent>(_gotContactsPicker);
  }

  Future<void> _gotContactsPicker(
    GotContactsPickerEvent event,
    Emitter<ContactsPickerState> emit,
  ) async {
    try {
      emit(ContactsPickerLoadingState());

      final contacts = await _contactsService.getContacts()
        ?..sort(
          (a, b) => a.name.compareTo(b.name),
        );

      if (contacts == null) {
        emit(
          ContactsPickerErrorState(
            errorMessage: 'Aconteceu um problema ao carregar os contatos.',
          ),
        );
        return;
      }

      if (contacts.isEmpty) {
        emit(ContactsPickerEmptyState());
        return;
      }

      emit(ContactsPickerLoadedState(contacts: contacts));
    } catch (e) {
      emit(
        ContactsPickerErrorState(
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }
}
