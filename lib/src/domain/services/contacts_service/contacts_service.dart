import 'package:bookify/src/domain/models/contact_model.dart';

abstract interface class ContactsService {
  Future<ContactModel?> getContactById({required String id});
  Future<List<ContactModel>?> getContacts();
}
