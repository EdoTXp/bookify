import 'package:bookify/src/features/contacts_picker/bloc/contacts_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final contactsPickerBlocProviders = [
  BlocProvider<ContactsPickerBloc>(
    create: (context) => ContactsPickerBloc(
      context.read(),
    ),
  ),
];
