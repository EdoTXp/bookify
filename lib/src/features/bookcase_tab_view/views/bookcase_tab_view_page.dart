import 'package:bookify/src/features/bookcase_tab_view/views/pages/pages.dart';
import 'package:flutter/material.dart';

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
        1 => 'Digite o título do livro emprestado.',
        2 => 'Digite o título dos seus livros.',
        0 || _ => 'Digite o nome da estante.',
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
              sliver: SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.only(top: 16.0),
                sliver: SliverAppBar(
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
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
                      visible: (_searchBarIsVisible &&
                          _searchController.text.isNotEmpty),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded),
                        tooltip: 'Apagar o texto.',
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
                          ? 'Desativar a barra de pesquisa.'
                          : 'Ativar a barra de pesquisa.',
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
                    labelStyle: const TextStyle(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: colorScheme.primary,
                    dividerHeight: 2,
                    dividerColor: colorScheme.primary.withOpacity(.6),
                    tabs: const [
                      Tab(text: 'Estantes'),
                      Tab(text: 'Empréstimos'),
                      Tab(text: 'Meus Livros'),
                    ],
                    onTap: (selectedTab) {
                      _setSearchHintText(selectedTab);
                      _disableSearchBar();
                    },
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              BookcasePage(
                searchQuery: _searchQuery,
              ),
              LoanPage(
                searchQuery: _searchQuery,
              ),
              MyBooksPage(
                searchQuery: _searchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
