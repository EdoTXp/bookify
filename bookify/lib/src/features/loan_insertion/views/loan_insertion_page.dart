//import 'package:bookify/src/features/loan_insertion/bloc/loan_insertion_bloc.dart';
import 'package:bookify/src/features/contacts_picker/views/contacts_picker_page.dart';
import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/features/loan_insertion/views/widgets/widgets.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';

class LoanInsertionPage extends StatefulWidget {
  /// The Route Name = '/loan_insertion'
  static const routeName = '/loan_insertion';
  final LoanDto? loanDto;

  const LoanInsertionPage({
    super.key,
    this.loanDto,
  });

  @override
  State<LoanInsertionPage> createState() => _LoanInsertionPageState();
}

class _LoanInsertionPageState extends State<LoanInsertionPage> {
  late final TextEditingController contactNameEC;
  late final TextEditingController contactPhoneNumberEC;
  late final TextEditingController observationEC;
  late final TextEditingController loanDateEC;
  late final TextEditingController devolutionDateEC;

  // late final LoanInsertionBloc _bloc;
  ContactDto? contact;

  @override
  void initState() {
    super.initState();
    // _bloc = context.read<LoanInsertionBloc>();

    contactNameEC = TextEditingController();
    contactPhoneNumberEC = TextEditingController();
    observationEC = TextEditingController();
    loanDateEC = TextEditingController();
    devolutionDateEC = TextEditingController();
  }

  void _clearData() {
    contactNameEC.clear();
    contactPhoneNumberEC.clear();
    observationEC.clear();
    loanDateEC.clear();
    devolutionDateEC.clear();

    setState(() {
      contact = null;
    });
  }

  Future<void> _getContact(BuildContext context) async {
    final contactDto = await showModalBottomSheet<ContactDto?>(
      context: context,
      builder: (context) => const ContactsPickerPage(),
    );

    if (contactDto != null) {
      setState(() {
        contact = contactDto;
      });
      contactNameEC.text = contactDto.name;
      contactPhoneNumberEC.text = contactDto.phoneNumber ?? 'sem número';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Criar empréstimo',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            tooltip: 'Limpar todos os campos',
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
            onPressed: _clearData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                 height: 10,
              ),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    EmptyBookButtonWidget(
                      onTap: () {},
                      height: 250,
                      width: 170,
                    ),
                    Positioned(
                      right: -20,
                      top: -20,
                      child: contact == null
                          ? EmptyContactButtonWidget(
                              onTap: () async => await _getContact(context),
                              height: 80,
                              width: 80,
                            )
                          : ContactCircleAvatar(
                              name: contact!.name,
                              photo: contact!.photo,
                              onTap: () async => await _getContact(context),
                              height: 80,
                              width: 80,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: contactNameEC,
                style: const TextStyle(fontSize: 14),
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: contactPhoneNumberEC,
                style: const TextStyle(fontSize: 14),
                enabled: false,
                decoration: const InputDecoration(
                  label: Text('Contato'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: observationEC,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  label: Text('Observação'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: loanDateEC,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        label: Text('Data do empréstimo'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: devolutionDateEC,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        label: Text('Data para devolução'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              BookifyElevatedButton.expanded(
                text: 'Enviar',
                onPressed: () {
                  /*   _bloc.add(
                    InsertedLoanInsertionEvent(),
                    ),
                  );*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
