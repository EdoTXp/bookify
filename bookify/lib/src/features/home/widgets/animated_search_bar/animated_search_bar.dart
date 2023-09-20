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
  bool _textIsEmpty = true;
  bool _iconButtonIsClicked = false;  // this active the SegmentedButton

  @override
  void initState() {
    super.initState();

    widget.searchEC.addListener(() {
      final searchTextIsEmpty = widget.searchEC.value.text.isEmpty;

      setState(() => _textIsEmpty = searchTextIsEmpty ? true : false);
    });
  }

  @override
  void dispose() {
    widget.searchEC.dispose();
    super.dispose();
  }

  void _clearSearchBar() {
    if (widget.searchEC.text.isNotEmpty) {
      setState(widget.searchEC.clear);
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
    final (hintText, searchIcon) = _updateSearchBar();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchBar(
          controller: widget.searchEC,
          onSubmitted: (value) {
            _iconButtonIsClicked = false;
            widget.onSubmitted(value, _searchType);
          },
          hintText: hintText,
          leading: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          trailing: [
            IconButton(
              onPressed: () {
                setState(() =>
                    _iconButtonIsClicked = !_iconButtonIsClicked);
              },
              icon: Icon(
                searchIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
              visible: !_textIsEmpty,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: _clearSearchBar,
              ),
            ),
          ],
        ),
        Visibility(
          visible: _iconButtonIsClicked,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SegmentedButton<SearchType>(
              segments: const [
                ButtonSegment<SearchType>(
                    value: SearchType.title,
                    //   label: Text('Título'),
                    icon: Icon(Icons.menu_book_rounded)),
                ButtonSegment<SearchType>(
                    value: SearchType.author,
                    //   label: Text('Autor'),
                    icon: Icon(Icons.person)),
                ButtonSegment<SearchType>(
                    value: SearchType.category,
                    //    label: Text('Gênero'),
                    icon: Icon(Icons.category)),
                ButtonSegment<SearchType>(
                    value: SearchType.publisher,
                    //      label: Text('Editora'),
                    icon: Icon(Icons.publish)),
                ButtonSegment<SearchType>(
                    value: SearchType.isbn,
                    //     label: Text('ISBN'),
                    icon: Icon(Icons.qr_code)),
              ],
              selected: <SearchType>{_searchType},
              onSelectionChanged: (Set<SearchType> newSelection) {
                setState(() {
                  _searchType = newSelection.first;
                  _clearSearchBar();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
