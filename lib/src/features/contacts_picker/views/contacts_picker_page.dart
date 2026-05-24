import 'package:bookify/src/core/helpers/platform_error_code/platform_error_code_extension.dart';
import 'package:bookify/src/features/contacts_picker/bloc/contacts_picker_bloc.dart';
import 'package:bookify/src/features/contacts_picker/views/widgets/contacts_picker_loaded_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class ContactsPickerPage extends StatefulWidget {
  /// The Route Name = '/contacts_picker'
  static const routeName = '/contacts_picker';

  const ContactsPickerPage({super.key});

  @override
  State<ContactsPickerPage> createState() => _ContactsPickerPageState();
}

class _ContactsPickerPageState extends State<ContactsPickerPage> {
  late ContactsPickerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ContactsPickerBloc>()..add(GotContactsPickerEvent());
  }

  void _onRefresh() {
    _bloc.add(GotContactsPickerEvent());
  }

  Widget _getWidgetOnContactsPickerState(
    BuildContext context,
    ContactsPickerState state,
  ) {
    return switch (state) {
      ContactsPickerLoadingState() => const CenterCircularProgressIndicator(),
      ContactsPickerEmptyState() => Center(
        child: InfoItemStateWidget.withNotFoundState(
          message: 'no-contacts-found'.i18n(),
          onPressed: _onRefresh,
        ),
      ),
      ContactsPickerLoadedState(:final contacts) =>
        ContactsPickerLoadedStateWidget(
          key: const Key('ContactsPickerLoadedStateWidget'),
          contacts: contacts,
          onSelectedContact: (contactDto) => Navigator.pop(context, contactDto),
        ),
      ContactsPickerErrorState(
        :final errorCode,
        :final errorDescriptionMessage,
      ) =>
        Center(
          child: InfoItemStateWidget.withErrorState(
            message: errorCode.toLocalizedMessage(errorDescriptionMessage),
            onPressed: _onRefresh,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsPickerBloc, ContactsPickerState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'contacts-label'.i18n(),
              style: TextStyle(fontSize: 16),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _getWidgetOnContactsPickerState(context, state),
          ),
        );
      },
    );
  }
}
