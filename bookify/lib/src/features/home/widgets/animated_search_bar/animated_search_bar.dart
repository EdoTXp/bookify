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
  final TextEditingController controller;

  const AnimatedSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

// TODO Add TransitionAnimation 

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  SearchType searchType = SearchType.title;

  final searchEC = TextEditingController();
  bool textVisible = false;
  bool segmentedButtonVisible = false;

  void _clearSearchBox() {
    searchEC.clear();
    textVisible = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IconData searchIcon = switch (searchType) {
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
          controller: searchEC,
          onChanged: (value) {
            setState(
              () => value.isNotEmpty ? textVisible = true : textVisible = false,
            );
          },
          onSubmitted: (value) {
            segmentedButtonVisible = false;
            widget.onSubmitted(value, searchType);
          },
          hintText: 'Título, autor(a), ISBN...',
          leading: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          trailing: [
            IconButton(
              onPressed: () {
                setState(
                    () => segmentedButtonVisible = !segmentedButtonVisible);
              },
              icon: Icon(
                searchIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Visibility(
              visible: textVisible,
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
          visible: segmentedButtonVisible,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
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
              selected: <SearchType>{searchType},
              onSelectionChanged: (Set<SearchType> newSelection) {
                setState(() {
                  _clearSearchBox();
                  searchType = newSelection.first;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
