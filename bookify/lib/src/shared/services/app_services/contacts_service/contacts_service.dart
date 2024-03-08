import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_contacts/fast_contacts.dart';

class ContactsService {
  Future<ContactDto?> getContactById({required String id}) async {
    if (await Permission.contacts.request().isGranted) {
      final contact = await FastContacts.getContact(
        id,
        fields: [
          ContactField.displayName,
          ContactField.phoneNumbers,
        ],
      );
      final photo = await FastContacts.getContactImage(id);

      if (contact != null) {
        return ContactDto(
          id: contact.id,
          name: contact.displayName,
          phoneNumber: contact.phones.first.number,
          photo: photo,
        );
      }
    }
    return null;
  }

  Future<ContactDto?> showExternalViewToGetContact() async {
    return null;
  }
}
