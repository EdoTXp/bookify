import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/models/contact_model.dart';
import 'package:bookify/src/core/services/contacts_service/contacts_service.dart';
import 'package:bookify/src/shared/enums/platform_error_code.dart';
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

      if (contacts == null || contacts.isEmpty) {
        emit(ContactsPickerEmptyState());
        return;
      }

      emit(ContactsPickerLoadedState(contacts: contacts));
    } on PlatformException catch (e) {
      emit(
        ContactsPickerErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        ContactsPickerErrorState(
          errorCode: PlatformErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
