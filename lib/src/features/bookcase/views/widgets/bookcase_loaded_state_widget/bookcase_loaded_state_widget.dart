import 'package:bookify/src/features/bookcase_detail/views/bookcase_detail_page.dart';
import 'package:bookify/src/features/bookcase_insertion/views/bookcase_insertion_page.dart';
import 'package:bookify/src/core/dtos/bookcase_dto.dart';
import 'package:bookify/src/core/services/app_services/show_dialog_service/show_dialog_service.dart';
import 'package:bookify/src/shared/widgets/bookcase_widget/bookcase_widget.dart';
import 'package:bookify/src/shared/widgets/buttons/add_new_item_text_button.dart';
import 'package:bookify/src/shared/widgets/list/selected_item_row/selected_item_row.dart';
import 'package:flutter/material.dart';

class BookcaseLoadedStateWidget extends StatefulWidget {
  final List<BookcaseDto> bookcasesDto;
  final VoidCallback onRefresh;
  final void Function(List<BookcaseDto> selectedBookcase) onPressedDeleteButton;

  const BookcaseLoadedStateWidget({
    super.key,
    required this.bookcasesDto,
    required this.onRefresh,
    required this.onPressedDeleteButton,
  });

  @override
  State<BookcaseLoadedStateWidget> createState() =>
      _BookcaseLoadedStateWidgetState();
}

class _BookcaseLoadedStateWidgetState extends State<BookcaseLoadedStateWidget> {
  bool _isSelectionMode = false;
  late final List<BookcaseDto> _selectedList;

  @override
  void initState() {
    super.initState();
    _selectedList = [];
  }

  Future<void> _normalOnTap(BuildContext context, bookcase) async {
    await Navigator.pushNamed(
      context,
      BookcaseDetailPage.routeName,
      arguments: bookcase,
    );
    widget.onRefresh();
  }

  void _onTap({required BuildContext context, required BookcaseDto element}) {
    if (_isSelectionMode) {
      setState(() {
        if (!_selectedList.contains(element)) {
          _selectedList.add(element);
        } else {
          _selectedList.remove(element);
        }

        _setIsSelectedMode();
      });
    } else {
      _normalOnTap(context, element.bookcase);
    }
  }

  void _onLongPress({required BookcaseDto element}) {
    setState(() {
      !_selectedList.contains(element)
          ? _selectedList.add(element)
          : _selectedList.remove(element);

      _setIsSelectedMode();
    });
  }

  void _setIsSelectedMode() {
    _isSelectionMode = _selectedList.isNotEmpty;
  }

  void _selectAllItems(List<BookcaseDto> bookcasesDto) {
    setState(() {
      _selectedList.replaceRange(
        0,
        _selectedList.length,
        bookcasesDto,
      );
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedList.clear();
      _setIsSelectedMode();
    });
  }

  Future<void> _onAddNewBookcase(BuildContext context) async {
    var bookcaseInsertionList = await Navigator.pushNamed(
      context,
      BookcaseInsertionPage.routeName,
    ) as List<Object?>?;

    final isInserted = bookcaseInsertionList?[0] as bool?;

    if (isInserted != null && isInserted) {
      widget.onRefresh();
    }
  }

  Widget _buildBookcaseWidget(
    List<BookcaseDto> bookcasesDto,
    int index,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    return (_selectedList.contains(bookcasesDto[index]))
        ? Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(.2),
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: BookcaseWidget(
                bookcaseDto: bookcasesDto[index],
                onTap: () => _onTap(
                  context: context,
                  element: bookcasesDto[index],
                ),
                onLongPress: () => _onLongPress(
                  element: bookcasesDto[index],
                ),
              ),
            ),
          )
        : BookcaseWidget(
            bookcaseDto: bookcasesDto[index],
            onTap: () => _onTap(
              context: context,
              element: bookcasesDto[index],
            ),
            onLongPress: () => _onLongPress(
              element: bookcasesDto[index],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookcasesDto = widget.bookcasesDto;

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: (_isSelectionMode)
              ? SelectedItemRow(
                  itemQuantity: _selectedList.length,
                  itemLabelSingular: 'Estante',
                  itemLabelPlural: 'Estantes',
                  onSelectedAll: (isSelectedAll) => (isSelectedAll)
                      ? _selectAllItems(bookcasesDto)
                      : _clearSelection(),
                  onPressedDeleteButton: () {
                    ShowDialogService.showAlertDialog(
                      context: context,
                      title: 'Deletar estantes',
                      content:
                          'Clicando em "CONFIRMAR" você removerá as estantes.\nTem Certeza?',
                      confirmButtonFunction: () {
                        Navigator.of(context).pop();
                        widget.onPressedDeleteButton(_selectedList);
                      },
                    );
                  },
                )
              : AddNewItemTextButton(
                  label: 'Adicionar uma nova estante',
                  onPressed: () async => await _onAddNewBookcase(context),
                ),
        ),
        Expanded(
          child: GestureDetector(
            // Verify that the list is selected before deselecting it if click outside the BookcaseWidget.
            onTap: () => _selectedList.isNotEmpty ? _clearSelection() : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              child: ListView.builder(
                itemCount: bookcasesDto.length,
                itemBuilder: (_, index) {
                  return _buildBookcaseWidget(
                    bookcasesDto,
                    index,
                    colorScheme,
                    context,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
