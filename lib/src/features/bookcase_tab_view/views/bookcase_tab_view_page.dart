import 'package:bookify/src/features/bookcase_tab_view/views/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class BookcaseTabViewPage extends StatefulWidget {
  const BookcaseTabViewPage({super.key});

  @override
  State<BookcaseTabViewPage> createState() => _BookcaseTabViewPageState();
}

class _BookcaseTabViewPageState extends State<BookcaseTabViewPage> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  late bool _searchBarIsVisible;
  late String _searchHintText;

  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _searchBarIsVisible = false;
    _setSearchHintText(0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setSearchHintText(int selectedTab) {
    setState(() {
      _searchHintText = switch (selectedTab) {
        1 => 'enter-loaned-title-label'.i18n(),
        2 => 'enter-title-your-book-label'.i18n(),
        0 || _ => 'enter-bookcase-name-label'.i18n(),
      };
    });
  }

  void _setSearchQuery(String actualSearchQuery) {
    setState(() {
      _searchQuery = (actualSearchQuery.length >= 3) ? actualSearchQuery : null;
    });
  }

  void _disableSearchBar() {
    setState(() {
      _searchBarIsVisible = false;
      _clearText();
      _focusNode.unfocus();
    });
  }

  void _clearText() {
    setState(() {
      _searchController.clear();
      _searchQuery = null;
    });
  }

  void _toggleSearchBarVisible() {
    setState(() {
      _searchBarIsVisible = !_searchBarIsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                title: Offstage(
                  offstage: !_searchBarIsVisible,
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: _searchHintText,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onTap: () => (_searchQuery != null)
                        ? _setSearchQuery(_searchQuery!)
                        : null,
                    onTapOutside: (_) => _focusNode.unfocus(),
                    onChanged: _setSearchQuery,
                  ),
                ),
                actions: [
                  Visibility(
                    visible:
                        (_searchBarIsVisible &&
                        _searchController.text.isNotEmpty),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'delete-text-typed-tooltip'.i18n(),
                      onPressed: _clearText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      (_searchBarIsVisible)
                          ? Icons.search_off_rounded
                          : Icons.search_rounded,
                    ),
                    tooltip: (_searchBarIsVisible)
                        ? 'disable-search-bar-tooltip'.i18n()
                        : 'enable-search-bar-tooltip'.i18n(),
                    onPressed: () {
                      if (_searchBarIsVisible) {
                        _clearText();
                        _focusNode.unfocus();
                      } else {
                        _focusNode.requestFocus();
                      }

                      _toggleSearchBarVisible();
                    },
                  ),
                ],
                bottom: TabBar(
                  tabAlignment: TabAlignment.fill,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: colorScheme.primary,
                  dividerHeight: 2,
                  dividerColor: colorScheme.primary.withValues(
                    alpha: .6,
                  ),
                  tabs: [
                    Tab(
                      key: Key('Bookcases TabView'),
                      text: 'bookcases-label'.i18n(),
                    ),
                    Tab(
                      key: Key('LoanTabView'),
                      text: 'loans-label'.i18n(),
                    ),
                    Tab(
                      key: Key('My Books TabView'),
                      text: 'my-books-label'.i18n(),
                    ),
                  ],
                  onTap: (selectedTab) {
                    _setSearchHintText(selectedTab);
                    _disableSearchBar();
                  },
                ),
              ),
            ),
          ],
          body: SafeArea(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BookcasePage(searchQuery: _searchQuery),
                LoanPage(searchQuery: _searchQuery),
                MyBooksPage(searchQuery: _searchQuery),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
