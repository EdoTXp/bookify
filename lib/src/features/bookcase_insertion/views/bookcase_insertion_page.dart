import 'package:bookify/src/features/bookcase_insertion/bloc/bookcase_insertion_bloc.dart';
import 'package:bookify/src/core/helpers/textfield_unfocus/textfield_unfocus_extension.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/services/app_services/color_picker_dialog_service/color_picker_dialog_service.dart';
//import 'package:bookify/src/core/services/app_services/lock_screen_orientation_service/lock_screen_orientation_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class BookcaseInsertionPage extends StatefulWidget {
  /// The Route Name = '/bookcase_insertion'
  static const routeName = '/bookcase_insertion';

  final BookcaseModel? bookcaseModel;

  const BookcaseInsertionPage({
    super.key,
    this.bookcaseModel,
  });

  @override
  State<BookcaseInsertionPage> createState() => _BookcaseInsertionPageState();
}

class _BookcaseInsertionPageState extends State<BookcaseInsertionPage> {
  final _formKey = GlobalKey<FormState>();
  final _bookcaseNameEC = TextEditingController();
  final _bookcaseDescriptionEC = TextEditingController();

  BookcaseModel? bookcaseUpdated;
  late BookcaseInsertionBloc _bloc;
  late bool _canPopPage;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    /*/  LockScreenOrientationService.lockOrientationScreen(
      orientation: Orientation.portrait,
    );*/
    _canPopPage = true;

    _bloc = context.read<BookcaseInsertionBloc>();

    _bookcaseNameEC.text = widget.bookcaseModel?.name ?? '';
    _bookcaseDescriptionEC.text = widget.bookcaseModel?.description ?? '';
    _selectedColor = widget.bookcaseModel?.color ?? Colors.white;
  }

  @override
  void dispose() {
    //   LockScreenOrientationService.unLockOrientationScreen();
    _bookcaseNameEC.dispose();
    _bookcaseDescriptionEC.dispose();
    super.dispose();
  }

  void _clearAllTextField() {
    _formKey.currentState!.reset();
    _bookcaseNameEC.clear();
    _bookcaseDescriptionEC.clear();

    setState(() {
      _selectedColor = Colors.white;
    });
  }

  /// Checks whether all fields are valid,
  /// then enters the new or update bookcase.
  void _onPressedButton(BookcaseModel? bookcaseModel) {
    if (_formKey.currentState!.validate()) {
      if (bookcaseModel == null) {
        _bloc.add(
          InsertedBookcaseEvent(
            name: _bookcaseNameEC.value.text,
            description: _bookcaseDescriptionEC.value.text,
            color: _selectedColor,
          ),
        );
      } else {
        _bloc.add(
          UpdatedBookcaseEvent(
            id: bookcaseModel.id!,
            name: _bookcaseNameEC.value.text,
            description: _bookcaseDescriptionEC.value.text,
            color: _selectedColor,
          ),
        );

        bookcaseUpdated = bookcaseModel.copyWith(
            name: _bookcaseNameEC.value.text,
            description: _bookcaseDescriptionEC.value.text,
            color: _selectedColor);
      }

      setState(() {
        _canPopPage = false;
      });
    }
  }

  Future<void> _handleBookcaseInsertionState(
    BuildContext context,
    BookcaseInsertionState state,
  ) async {
    switch (state) {
      case BookcaseInsertionLoadingState():
        SnackbarService.showSnackBar(
          context,
          'Aguarde um instante...',
          SnackBarType.info,
        );

        break;
      case BookcaseInsertionInsertedState(
          bookcaseInsertionMessage: final successMessage,
        ):
        SnackbarService.showSnackBar(
          context,
          successMessage,
          SnackBarType.success,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop([
                true,
                bookcaseUpdated,
              ]);
            }
          },
        );
        break;
      case BookcaseInsertionErrorState(:final errorMessage):
        SnackbarService.showSnackBar(
          context,
          errorMessage,
          SnackBarType.error,
        );

        await Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookcaseModel = widget.bookcaseModel;

    final String titlePage =
        (bookcaseModel == null) ? 'Criar estante' : 'Editar estante';

    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<BookcaseInsertionBloc, BookcaseInsertionState>(
      bloc: _bloc,
      listener: _handleBookcaseInsertionState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              titlePage,
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              IconButton(
                onPressed: _clearAllTextField,
                tooltip: 'Limpar todos os campos',
                icon: const Icon(Icons.delete_forever_outlined),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                canPop: _canPopPage,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      key: const Key('Bookcase name TextFormField'),
                      controller: _bookcaseNameEC,
                      cursorColor: colorScheme.secondary,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required(
                            'Esse campo não pode estar vazio',
                          ),
                          Validatorless.min(
                            3,
                            'Esse campo precisa ter no mínimo 3 caracteres',
                          ),
                        ],
                      ),
                      onTapOutside: (_) => context.unfocus(),
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const Key('Bookcase description TextFormField'),
                      controller: _bookcaseDescriptionEC,
                      cursorColor: colorScheme.secondary,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: Validatorless.required(
                        'Esse campo não pode estar vazio',
                      ),
                      onTapOutside: (_) => context.unfocus(),
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const Key('Bookcase color TextFormField'),
                      style: const TextStyle(fontSize: 16),
                      readOnly: true,
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        _selectedColor = await ColorPickerDialogService
                            .showColorPickerDialog(
                          context,
                          _selectedColor,
                        );
                      },
                      onTapOutside: (_) => context.unfocus(),
                      decoration: InputDecoration(
                        labelText: 'Cor',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              border: Border.all(color: colorScheme.primary),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down_rounded,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BookifyOutlinedButton.expanded(
                      key: const Key('Confirm Bookcase insertion Button'),
                      text: 'Confirmar',
                      onPressed: () => _onPressedButton(bookcaseModel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
