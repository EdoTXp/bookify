import 'package:bookify/src/features/bookcase_insertion/bloc/bookcase_insertion_bloc.dart';
import 'package:bookify/src/core/helpers/textfield_unfocus/textfield_unfocus_extension.dart';
import 'package:bookify/src/core/models/bookcase_model.dart';
import 'package:bookify/src/core/services/app_services/color_picker_dialog_service/color_picker_dialog_service.dart';
import 'package:bookify/src/core/services/app_services/snackbar_service/snackbar_service.dart';
import 'package:bookify/src/shared/widgets/buttons/bookify_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:validatorless/validatorless.dart';

/// Page for creating or updating a [BookcaseModel].
///
/// This page provides a form to input bookcase details such as name, description,
/// and color. It supports two modes:
/// - **Create mode**: For adding a new bookcase (see [newBookcase])
/// - **Edit mode**: For modifying an existing bookcase (see [updateBookcase])
///
/// The page returns a list containing:
/// - `result[0]`: A boolean indicating success
/// - `result[1]`: The updated or newly created [BookcaseModel]
class BookcaseInsertionPage extends StatefulWidget {
  /// The Route Name = '/bookcase_insertion'
  static const routeName = '/bookcase_insertion';

  /// The bookcase model to edit, or `null` if creating a new bookcase.
  final BookcaseModel? bookcaseModel;

  /// Private constructor for internal use only.
  ///
  /// Use [newBookcase] or [updateBookcase] factory constructors instead.
  const BookcaseInsertionPage._({
    super.key,
    required this.bookcaseModel,
  });

  /// Creates a new bookcase insertion page in create mode.
  ///
  /// Returns a page where the user can create a new bookcase with an empty form.
  factory BookcaseInsertionPage.newBookcase({Key? key}) {
    return BookcaseInsertionPage._(
      key: key,
      bookcaseModel: null,
    );
  }

  /// Creates a new bookcase insertion page in edit mode.
  ///
  /// The form will be pre-populated with the [bookcaseModel] data.
  ///
  /// Parameters:
  ///   - [bookcaseModel]: The bookcase to edit (required)
  ///   - [key]: Optional widget key
  factory BookcaseInsertionPage.updateBookcase({
    required BookcaseModel bookcaseModel,
    Key? key,
  }) {
    return BookcaseInsertionPage._(
      key: key,
      bookcaseModel: bookcaseModel,
    );
  }

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

    _canPopPage = true;

    _bloc = context.read<BookcaseInsertionBloc>();

    _bookcaseNameEC.text = widget.bookcaseModel?.name ?? '';
    _bookcaseDescriptionEC.text = widget.bookcaseModel?.description ?? '';
    _selectedColor = widget.bookcaseModel?.color ?? Colors.white;
  }

  @override
  void dispose() {
    _bookcaseNameEC.dispose();
    _bookcaseDescriptionEC.dispose();
    super.dispose();
  }

  /// Clears all text fields and resets the color to white.
  ///
  /// This resets the form to its initial state, useful for the user to start over.
  void _clearAllTextField() {
    _formKey.currentState!.reset();
    _bookcaseNameEC.clear();
    _bookcaseDescriptionEC.clear();

    setState(() {
      _selectedColor = Colors.white;
    });
  }

  /// Validates the form and processes the bookcase insertion or update.
  ///
  /// In **create mode**: Emits an [InsertedBookcaseEvent] to add a new bookcase.
  /// In **edit mode**: Emits an [UpdatedBookcaseEvent] to modify the existing bookcase.
  ///
  /// The [bookcaseUpdated] will be populated with the updated bookcase data in edit mode,
  /// which is then passed back through the navigation result.
  ///
  /// Sets [_canPopPage] to `false` to indicate the form is being processed

  /// Checks whether all fields are valid,
  /// then enters the new or update bookcase.
  void _onPressedButton() {
    if (_formKey.currentState!.validate()) {
      final isEditMode = widget.bookcaseModel != null;

      if (!isEditMode) {
        _bloc.add(
          InsertedBookcaseEvent(
            name: _bookcaseNameEC.value.text,
            description: _bookcaseDescriptionEC.value.text.isEmpty
                ? null
                : _bookcaseDescriptionEC.value.text,
            color: _selectedColor,
          ),
        );
      } else {
        final bookcaseModel = widget.bookcaseModel!;
        _bloc.add(
          UpdatedBookcaseEvent(
            id: bookcaseModel.id!,
            name: _bookcaseNameEC.value.text,
            description: _bookcaseDescriptionEC.value.text.isEmpty
                ? null
                : _bookcaseDescriptionEC.value.text,
            color: _selectedColor,
          ),
        );

        bookcaseUpdated = _bookcaseDescriptionEC.text.isEmpty
            ? bookcaseModel.copyWithDescriptionNull(
                name: _bookcaseNameEC.value.text,
                color: _selectedColor,
              )
            : bookcaseModel.copyWith(
                name: _bookcaseNameEC.value.text,
                description: _bookcaseDescriptionEC.value.text,
                color: _selectedColor,
              );
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
          'wait-snackbar'.i18n(),
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

    final String titlePage = (bookcaseModel == null)
        ? 'create-bookcase-title'.i18n()
        : 'edit-bookcase-title'.i18n();

    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<BookcaseInsertionBloc, BookcaseInsertionState>(
      bloc: _bloc,
      listener: _handleBookcaseInsertionState,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            titlePage,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            IconButton(
              key: const Key('ClearAllFieldsButton'),
              onPressed: _clearAllTextField,
              tooltip: 'clear-all-fields-button'.i18n(),
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
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const Key('BookcaseNameTextFormField'),
                    controller: _bookcaseNameEC,
                    cursorColor: colorScheme.secondary,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required(
                          'field-cannot-be-empty-error'.i18n(),
                        ),
                        Validatorless.min(
                          3,
                          'field-need-3-characters-error'.i18n(),
                        ),
                      ],
                    ),
                    onTapOutside: (_) => context.unfocus(),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'name-required-field'.i18n(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    key: const Key('BookcaseDescriptionTextFormField'),
                    controller: _bookcaseDescriptionEC,
                    cursorColor: colorScheme.secondary,
                    onTapOutside: (_) => context.unfocus(),
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'description-optional-field'.i18n(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  TextFormField(
                    key: const Key('BookcaseColorTextFormField'),
                    style: const TextStyle(fontSize: 16),
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    onTap: () async {
                      _selectedColor =
                          await ColorPickerDialogService.showColorPickerDialog(
                            context,
                            _selectedColor,
                          );
                    },
                    onTapOutside: (_) => context.unfocus(),
                    decoration: InputDecoration(
                      labelText: 'color-field'.i18n(),
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
                  Text(
                    'fields-required-label'.i18n(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  BookifyOutlinedButton.expanded(
                    key: const Key('ConfirmBookcaseInsertionButton'),
                    text: 'confirm-button-normal'.i18n(),
                    onPressed: _onPressedButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
