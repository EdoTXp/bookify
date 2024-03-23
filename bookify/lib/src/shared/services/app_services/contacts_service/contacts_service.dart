import 'package:bookify/src/shared/dtos/conctact_dto.dart';

abstract interface class ContactsService {
  Future<ContactDto?> getContactById({required String id});
  Future<List<ContactDto?>?> getContacts();
}
