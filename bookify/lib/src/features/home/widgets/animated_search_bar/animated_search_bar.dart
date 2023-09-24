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
  bool _searchTextIsEmpty = true;
  bool _searchIconByTypeIsClicked = false;

  @override
  void initState() {
    super.initState();

    widget.searchEC.addListener(() {
      _changeIconButtonVisibilityOnSearchTextIsEmpty();
    });
  }

  @override
  void dispose() {
    widget.searchEC.dispose();
    super.dispose();
  }

  void _changeIconButtonVisibilityOnSearchTextIsEmpty() {
    final bool searchTextIsEmpty = widget.searchEC.value.text.isEmpty;
    setState(() => _searchTextIsEmpty = searchTextIsEmpty ? true : false);
  }

  void _clearSearchBarText() {
    if (widget.searchEC.text.isNotEmpty) {
      setState(() => widget.searchEC.clear());
    }
  }

  (String hintText, IconData searchIcon) _updateSearchBar() {
    final searchMap = switch (_searchType) {
      SearchType.title => {'Digite o Título': Icons.menu_book_rounded},
      SearchType.author => {'Digite o Autor': Icons.person},
      SearchType.category => {'Digite o Gênero': Icons.category},
      SearchType.publisher => {'Digite a Editora': Icons.publish},
      SearchType.isbn => {'Digite o ISBN': Icons.qr_code},
    };

    return (searchMap.keys.first, searchMap.values.first);
  }

  @override
  Widget build(BuildContext context) {
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
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          trailing: [
            IconButton(
              onPressed: () {
                setState(() =>
                    _searchIconByTypeIsClicked = !_searchIconByTypeIsClicked);
              },
              icon: Icon(
                // Show icon selection based on the type of search selected
                searchIconByType,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
              visible: !_searchTextIsEmpty,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: _clearSearchBarText,
              ),
            ),
          ],
        ),
        Visibility(
          visible: _searchIconByTypeIsClicked,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SegmentedButton<SearchType>(
              segments: const [
                ButtonSegment<SearchType>(
                  value: SearchType.title,
                  icon: Icon(Icons.menu_book_rounded),
                ),
                ButtonSegment<SearchType>(
                  value: SearchType.author,
                  icon: Icon(Icons.person),
                ),
                ButtonSegment<SearchType>(
                  value: SearchType.category,
                  icon: Icon(Icons.category),
                ),
                ButtonSegment<SearchType>(
                  value: SearchType.publisher,
                  icon: Icon(Icons.publish),
                ),
                ButtonSegment<SearchType>(
                  value: SearchType.isbn,
                  icon: Icon(Icons.qr_code),
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
      ],
    );
  }
}
