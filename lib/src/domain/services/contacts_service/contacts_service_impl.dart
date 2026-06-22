import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/domain/models/contact_model.dart';
import 'package:bookify/src/domain/services/contacts_service/contacts_service.dart';
import 'package:bookify/src/core/enums/platform_error_code.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast_contacts/fast_contacts.dart';

class ContactsServiceImpl implements ContactsService {
  @override
  Future<ContactModel?> getContactById({required String id}) async {
    try {
      final permissionStatus = await Permission.contacts.request();

      if (permissionStatus.isGranted) {
        final contact = await FastContacts.getContact(
          id,
          fields: [
            ContactField.displayName,
            ContactField.phoneNumbers,
          ],
        );
        final photo = await FastContacts.getContactImage(id);

        if (contact != null) {
          return ContactModel(
            id: contact.id,
            name: contact.displayName,
            phoneNumber: (contact.phones.isNotEmpty)
                ? contact.phones.first.number
                : null,
            photo: photo,
          );
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
      }
      return null;
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<List<ContactModel>?> getContacts() async {
    try {
      final permissionStatus = await Permission.contacts.request();

      if (permissionStatus.isGranted) {
        final contacts = await FastContacts.getAllContacts(
          fields: [
            ContactField.displayName,
            ContactField.phoneNumbers,
          ],
        );

        final List<ContactModel> contactsDto = [];
        for (Contact contact in contacts) {
          final photo = await FastContacts.getContactImage(contact.id);

          final contactDto = ContactModel(
            id: contact.id,
            name: contact.displayName,
            phoneNumber: (contact.phones.isNotEmpty)
                ? contact.phones.first.number
                : null,
            photo: photo,
          );

          contactsDto.add(contactDto);
        }

        return contactsDto;
      } else if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
      }
      return null;
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
