import 'package:bookify/src/features/books_picker/views/books_picker_page.dart';
import 'package:bookify/src/features/contacts_picker/views/contacts_picker_page.dart';
import 'package:bookify/src/features/loan_insertion/bloc/loan_insertion_bloc.dart';
import 'package:bookify/src/shared/dtos/conctact_dto.dart';
import 'package:bookify/src/shared/dtos/loan_dto.dart';
import 'package:bookify/src/shared/helpers/date_time_format/date_time_format.dart';
import 'package:bookify/src/shared/helpers/form/form_helper.dart';
import 'package:bookify/src/shared/models/book_model.dart';
import 'package:bookify/src/shared/services/app_services/date_picker_dialog_service/date_picker_dialog_service.dart';
import 'package:bookify/src/shared/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/book_widget/book_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_elevated_button.dart';
import 'package:bookify/src/shared/widgets/contact_circle_avatar/contact_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:bookify/src/features/loan_insertion/views/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

/// The LoanInsertionPage widget is responsible for handling the loan insertion process.
/// It allows users to select a book and a contact, specify loan and devolution dates, and submit the loan information.
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
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _contactNameEC;
  late final TextEditingController _contactPhoneNumberEC;
  late final TextEditingController _observationEC;
  late final TextEditingController _loanDateEC;
  late final TextEditingController _devolutionDateEC;
  late final LoanInsertionBloc _bloc;
  late bool _canPopPage;

  ContactDto? _contact;
  BookModel? _bookModel;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _contactNameEC = TextEditingController();
    _contactPhoneNumberEC = TextEditingController();
    _observationEC = TextEditingController();
    _loanDateEC = TextEditingController();
    _devolutionDateEC = TextEditingController();
    _bloc = context.read<LoanInsertionBloc>();
    _canPopPage = true;
  }

  @override
  void dispose() {
    _contactNameEC.dispose();
    _contactPhoneNumberEC.dispose();
    _observationEC.dispose();
    _loanDateEC.dispose();
    _devolutionDateEC.dispose();

    super.dispose();
  }

  /// Clears all input fields, book and contact buttons.
  void _clearData() {
    _contactNameEC.clear();
    _contactPhoneNumberEC.clear();
    _observationEC.clear();
    _loanDateEC.clear();
    _devolutionDateEC.clear();

    setState(() {
      _contact = null;
      _bookModel = null;
    });
  }

  /// Opens a modal bottom sheet to select a contact.
  Future<void> _getContact(BuildContext context) async {
    final contactDto = await showModalBottomSheet<ContactDto?>(
      context: context,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const ContactsPickerPage(),
    );

    if (contactDto != null) {
      setState(() {
        _contact = contactDto;
      });
      _contactNameEC.text = contactDto.name;
      _contactPhoneNumberEC.text = contactDto.phoneNumber ?? 'sem número';
    }
  }

  /// Opens a modal bottom sheet to select a book.
  Future<void> _getBook(BuildContext context) async {
    final book = await showModalBottomSheet<BookModel?>(
      context: context,
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const BooksPickerPage(),
    );

    if (book != null) {
      setState(() {
        _bookModel = book;
      });
    }
  }

  /// Opens a date picker dialog to select loan and devolution dates.
  Future<void> _getDate(
    BuildContext context,
  ) async {
    final loanDate = (_loanDateEC.text.isNotEmpty)
        ? _loanDateEC.text.parseFormattedDate()
        : null;

    final devolutionDate = (_devolutionDateEC.text.isNotEmpty)
        ? _devolutionDateEC.text.parseFormattedDate()
        : null;

    final dateResult = await DatePickerDialogService.showDateTimePickerRange(
      context: context,
      value: [loanDate, devolutionDate],
    );

    if (dateResult != null) {
      _loanDateEC.text = dateResult.first!.toFormattedDate();
      _devolutionDateEC.text = dateResult.last!.toFormattedDate();
    }
  }

  /// Handles the state changes of the LoanInsertionBloc and shows appropriate snackbars.
  Future<void> _handleLoanInsertionState(
    BuildContext context,
    LoanInsertionState state,
  ) async {
    switch (state) {
      case LoanInsertionLoadingState():
        SnackbarService.showSnackBar(
          context,
          'Aguarde um instante...',
          SnackBarType.info,
        );

        break;

      case LoanInsertionInsertedState(
          loanInsertionMessage: final succesMessage,
        ):
        SnackbarService.showSnackBar(
          context,
          succesMessage,
          SnackBarType.success,
        );

        await Future.delayed(const Duration(seconds: 2))
            .then((_) => Navigator.of(context).pop());
        break;
      case LoanInsertionErrorState(:final errorMessage):
        SnackbarService.showSnackBar(
          context,
          errorMessage,
          SnackBarType.error,
        );

        await Future.delayed(const Duration(seconds: 2))
            .then((_) => Navigator.of(context).pop());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopPage,
      child: BlocConsumer<LoanInsertionBloc, LoanInsertionState>(
        bloc: _bloc,
        listener: _handleLoanInsertionState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Criar empréstimo de um livro',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            (_bookModel == null)
                                ? EmptyBookButtonWidget(
                                    onTap: () async => await _getBook(context),
                                    height: 250,
                                    width: 170,
                                  )
                                : Material(
                                    child: InkWell(
                                      onTap: () async =>
                                          await _getBook(context),
                                      child: BookWidget(
                                        bookImageUrl: _bookModel!.imageUrl,
                                        height: 250,
                                        width: 170,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              right: -20,
                              top: -20,
                              child: _contact == null
                                  ? EmptyContactButtonWidget(
                                      onTap: () async =>
                                          await _getContact(context),
                                      height: 80,
                                      width: 80,
                                    )
                                  : ContactCircleAvatar(
                                      name: _contact!.name,
                                      photo: _contact!.photo,
                                      onTap: () async =>
                                          await _getContact(context),
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
                        controller: _contactNameEC,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            Validatorless.required('Esse campo é obrigatório.'),
                        onTap: () async => await _getContact(context),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          label: Text('Nome'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _contactPhoneNumberEC,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            Validatorless.required('Esse campo é obrigatório.'),
                        onTap: () async => await _getContact(context),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          label: Text('Contato'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _observationEC,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator:
                            Validatorless.required('Esse campo é obrigatório'),
                        onTapOutside: (_) => context.unfocus(),
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
                              controller: _loanDateEC,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: true,
                              validator: Validatorless.required(
                                  'Esse campo é obrigatório'),
                              onTap: () async => await _getDate(context),
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
                              controller: _devolutionDateEC,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: true,
                              validator: Validatorless.required(
                                  'Esse campo é obrigatório'),
                              onTap: () async => await _getDate(context),
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
                          if (_formKey.currentState!.validate() &&
                              _bookModel != null) {
                            // Added 7 hours to the devolution date to ensure that the devolution date occurs on the desired day.
                            final devolutionDateWithHours = _devolutionDateEC
                                .text
                                .parseFormattedDate()
                                .add(const Duration(hours: 7));

                            _bloc.add(
                              InsertedLoanInsertionEvent(
                                idContact: _contact!.id,
                                bookId: _bookModel!.id,
                                bookTitle: _bookModel!.title,
                                contactName: _contactNameEC.text,
                                observation: _observationEC.text,
                                loanDate: _loanDateEC.text.parseFormattedDate(),
                                devolutionDate: devolutionDateWithHours,
                              ),
                            );

                            // disable popPage to ensure the loan is inserted.
                            setState(() {
                              _canPopPage = false;
                            });
                          } else {
                            // Informs the user that one of the textformfields or one of the contact or book buttons is empty.
                            // this way, cannot complete insert.
                            SnackbarService.showSnackBar(
                              context,
                              'Tem algum campo vazio.\nVerifique se adicionou o livro, o contato, a observação, e as datas.',
                              SnackBarType.error,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
