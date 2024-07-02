import 'package:bloc_test/bloc_test.dart';
import 'package:bookify/src/features/contacts_picker/bloc/contacts_picker_bloc.dart';
import 'package:bookify/src/core/dtos/contact_dto.dart';
import 'package:bookify/src/core/services/app_services/contacts_service/contacts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ContactsServiceMock extends Mock implements ContactsService {}

void main() {
  final contactsService = ContactsServiceMock();
  late ContactsPickerBloc contactsPickerBloc;

  final List<ContactDto> contacts = [
    const ContactDto(id: 'id', name: 'name'),
    const ContactDto(id: 'id2', name: 'name2'),
  ];

  setUp(() {
    contactsPickerBloc = ContactsPickerBloc(contactsService);
  });

  group('Test ContactsPickerBloc ||', () {
    blocTest(
      'Initial state is empty',
      build: () => contactsPickerBloc,
      verify: (bloc) async => await bloc.close(),
      expect: () => [],
    );

    blocTest(
      'Test GotContactsPickerEvent work',
      build: () => contactsPickerBloc,
      setUp: () => when(
        () => contactsService.getContacts(),
      ).thenAnswer((_) async => contacts),
      act: (bloc) => bloc.add(GotContactsPickerEvent()),
      verify: (_) => verify(() => contactsService.getContacts()).called(1),
      expect: () => [
        isA<ContactsPickerLoadingState>(),
        isA<ContactsPickerLoadedState>(),
      ],
    );

    blocTest(
      'Test GotContactsPickerEvent work when Contacts is null',
      build: () => contactsPickerBloc,
      setUp: () => when(
        () => contactsService.getContacts(),
      ).thenAnswer((_) async => null),
      act: (bloc) => bloc.add(GotContactsPickerEvent()),
      verify: (_) => verify(() => contactsService.getContacts()).called(1),
      expect: () => [
        isA<ContactsPickerLoadingState>(),
        isA<ContactsPickerErrorState>(),
      ],
    );

    blocTest(
      'Test GotContactsPickerEvent work when Contacts is empty',
      build: () => contactsPickerBloc,
      setUp: () => when(
        () => contactsService.getContacts(),
      ).thenAnswer((_) async => []),
      act: (bloc) => bloc.add(GotContactsPickerEvent()),
      verify: (_) => verify(() => contactsService.getContacts()).called(1),
      expect: () => [
        isA<ContactsPickerLoadingState>(),
        isA<ContactsPickerEmptyState>(),
      ],
    );

    blocTest(
      'Test GotContactsPickerEvent work when throw Generic Exception',
      build: () => contactsPickerBloc,
      setUp: () => when(
        () => contactsService.getContacts(),
      ).thenThrow(Exception('Generic Error')),
      act: (bloc) => bloc.add(GotContactsPickerEvent()),
      verify: (_) => verify(() => contactsService.getContacts()).called(1),
      expect: () => [
        isA<ContactsPickerLoadingState>(),
        isA<ContactsPickerErrorState>(),
      ],
    );
  });
}
