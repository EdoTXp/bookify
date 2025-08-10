import 'package:bookify/src/shared/constants/icons/bookify_icons.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

enum SearchType {
  title,
  author,
  category,
  publisher,
  isbn;
}

class AnimatedSearchBar extends StatefulWidget {
  final TextEditingController searchEC;
  final void Function(String value, SearchType searchType) onSubmitted;

  const AnimatedSearchBar({
    super.key,
    required this.searchEC,
    required this.onSubmitted,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  SearchType _searchType = SearchType.title;
  bool _searchIconByTypeIsClicked = false;

  void _clearSearchBarText() {
    if (widget.searchEC.text.isNotEmpty) widget.searchEC.clear();
  }

  (String hintText, IconData searchIcon) _updateSearchBar() {
    final searchMap = switch (_searchType) {
      SearchType.title => {'enter-title-label'.i18n(): Icons.menu_book_rounded},
      SearchType.author => {'enter-author-label'.i18n(): Icons.person_rounded},
      SearchType.category => {
          'enter-category-label'.i18n(): Icons.category_rounded
        },
      SearchType.publisher => {
          'enter-publisher-label'.i18n(): Icons.publish_rounded
        },
      SearchType.isbn => {'enter-isbn-label'.i18n(): BookifyIcons.isbn},
    };

    return (searchMap.keys.first, searchMap.values.first);
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.secondary;
    final (searchHintText, searchIconByType) = _updateSearchBar();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchBar(
          controller: widget.searchEC,
          onSubmitted: (value) {
            widget.searchEC.text = value.trim();
            _searchIconByTypeIsClicked = false;

            if (widget.searchEC.text.isNotEmpty) {
              widget.onSubmitted(widget.searchEC.text, _searchType);
            } else {
              _clearSearchBarText();
            }
          },
          hintText: searchHintText,
          leading: Icon(
            Icons.search_rounded,
            color: selectedColor,
          ),
          trailing: [
            ValueListenableBuilder(
              valueListenable: widget.searchEC,
              builder: (context, value, _) {
                if (value.text.isNotEmpty) {
                  return IconButton(
                    tooltip: 'delete-text-typed-tooltip'.i18n(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: selectedColor,
                    ),
                    onPressed: _clearSearchBarText,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            IconButton(
              key: const Key('Search Type Button'),
              tooltip: 'change-search-type-tooltip'.i18n(),
              onPressed: () {
                setState(
                  () =>
                      _searchIconByTypeIsClicked = !_searchIconByTypeIsClicked,
                );
              },
              icon: Column(
                children: [
                  Icon(
                    searchIconByType,
                    color: selectedColor,
                  ),
                  // Dot below the icon to indicate it is a button
                  Container(
                    height: 4,
                    width: 4,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: _searchIconByTypeIsClicked,
          maintainAnimation: true,
          maintainState: true,
          child: AnimatedOpacity(
            opacity: _searchIconByTypeIsClicked ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: SegmentedButton<SearchType>(
                style: ButtonStyle(
                  iconColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white
                        : selectedColor,
                  ),
                ),
                segments: [
                  ButtonSegment<SearchType>(
                    value: SearchType.title,
                    tooltip: 'search-by-title-tooltip'.i18n(),
                    icon: Icon(
                      key: Key('Title Search Type Button'),
                      Icons.menu_book_rounded,
                    ),
                  ),
                  ButtonSegment<SearchType>(
                    value: SearchType.author,
                    tooltip: 'search-by-author-tooltip'.i18n(),
                    icon: Icon(
                      key: Key('Author Search Type Button'),
                      Icons.person_rounded,
                    ),
                  ),
                  ButtonSegment<SearchType>(
                    value: SearchType.category,
                    tooltip: 'search-by-category-tooltip'.i18n(),
                    icon: Icon(
                      key: Key('Category Search Type Button'),
                      Icons.category_rounded,
                    ),
                  ),
                  ButtonSegment<SearchType>(
                    value: SearchType.publisher,
                    tooltip: 'search-by-publisher-tooltip'.i18n(),
                    icon: Icon(
                      key: Key('Publisher Search Type Button'),
                      Icons.publish_rounded,
                    ),
                  ),
                  ButtonSegment<SearchType>(
                    value: SearchType.isbn,
                    tooltip: 'search-by-isbn-tooltip'.i18n(),
                    icon: Icon(
                      key: Key('ISBN Search Type Button'),
                      BookifyIcons.isbn,
                    ),
                  ),
                ],
                selected: <SearchType>{_searchType},
                onSelectionChanged: (Set<SearchType> newSelection) {
                  setState(() {
                    _searchType = newSelection.first;
                    _clearSearchBarText();
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
