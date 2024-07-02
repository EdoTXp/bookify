import 'package:bookify/src/core/dtos/contact_dto.dart';

abstract interface class ContactsService {
  Future<ContactDto?> getContactById({required String id});
  Future<List<ContactDto>?> getContacts();
}
