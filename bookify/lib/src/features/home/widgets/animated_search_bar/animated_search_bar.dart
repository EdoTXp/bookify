import 'package:flutter/material.dart';

enum SearchType {
  title,
  author,
  category,
  publisher,
  isbn;
}

class AnimatedSearchBar extends StatefulWidget {
  final void Function(String value, SearchType searchType) onSubmitted;
  final TextEditingController searchEC;

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
  bool _textVisible = false;
  bool _segmentedButtonVisible = false;

  void _clearSearchBox() {
    widget.searchEC.clear();
    _textVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    IconData searchIcon = switch (_searchType) {
      SearchType.title => Icons.menu_book_rounded,
      SearchType.author => Icons.person,
      SearchType.category => Icons.category,
      SearchType.publisher => Icons.publish,
      SearchType.isbn => Icons.qr_code,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchBar(
          controller: widget.searchEC,
          onChanged: (value) {
            setState(
              () =>
                  value.isNotEmpty ? _textVisible = true : _textVisible = false,
            );
          },
          onSubmitted: (value) {
            _segmentedButtonVisible = false;
            widget.onSubmitted(value, _searchType);
          },
          hintText: 'Título, autor(a), ISBN...',
          leading: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          trailing: [
            IconButton(
              onPressed: () {
                setState(() {
                  _segmentedButtonVisible = !_segmentedButtonVisible;
                });
              },
              icon: Icon(
                searchIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
              visible: _textVisible,
              child: IconButton(
                onPressed: () {
                  setState(() => _clearSearchBox());
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: _segmentedButtonVisible,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SegmentedButton<SearchType>(
              segments: const [
                ButtonSegment<SearchType>(
                    value: SearchType.title,
                    label: Text('Título'),
                    icon: Icon(Icons.menu_book_rounded)),
                ButtonSegment<SearchType>(
                    value: SearchType.author,
                    label: Text('Autor'),
                    icon: Icon(Icons.person)),
                ButtonSegment<SearchType>(
                    value: SearchType.category,
                    label: Text('Gênero'),
                    icon: Icon(Icons.category)),
                ButtonSegment<SearchType>(
                    value: SearchType.publisher,
                    label: Text('Editora'),
                    icon: Icon(Icons.publish)),
                ButtonSegment<SearchType>(
                    value: SearchType.isbn,
                    label: Text('ISBN'),
                    icon: Icon(Icons.qr_code)),
              ],
              selected: <SearchType>{_searchType},
              onSelectionChanged: (Set<SearchType> newSelection) {
                setState(() {
                  _clearSearchBox();
                  _searchType = newSelection.first;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
