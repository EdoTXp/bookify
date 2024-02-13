import 'package:bookify/src/features/bookcase_tab_view/views/pages/pages.dart';
import 'package:flutter/material.dart';

class BookcaseTabViewPage extends StatefulWidget {
  const BookcaseTabViewPage({super.key});

  @override
  State<BookcaseTabViewPage> createState() => _BookcaseTabViewPageState();
}

class _BookcaseTabViewPageState extends State<BookcaseTabViewPage> {
  late TextEditingController _searchController;
  late bool _searchBarIsVisible;
  late String _searchHint;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchBarIsVisible = false;
    _setSearchHint(0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setSearchHint(int value) {
    setState(() {
      _searchHint = switch (value) {
        1 => 'Digite o nome do livro emprestado.',
        2 => 'Digite o nome dos seus livros.',
        0 || _ => 'Digite o nome da estante.',
      };
    });
  }

  void _disableSearchBar() {
    setState(() {
      _searchBarIsVisible = false;
      _searchController.clear();
    });
  }

  void _onPressedSearchButton() {
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
        appBar: AppBar(
          title: Visibility(
            visible: _searchBarIsVisible,
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: _searchHint,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onSubmitted: (_) => _disableSearchBar(),
              style: const TextStyle(fontSize: 14),
              controller: _searchController,
            ),
          ),
          actions: [
            Visibility(
              visible: _searchBarIsVisible,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Apagar o texto.',
                onPressed: _searchController.clear,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: (_searchBarIsVisible)
                  ? 'Desativar a barra de pesquisa.'
                  : 'Ativar a barra de pesquisa.',
              onPressed: _onPressedSearchButton,
            ),
          ],
          bottom: TabBar(
            tabAlignment: TabAlignment.fill,
            onTap: (value) {
              _setSearchHint(value);
              _disableSearchBar();
            },
            tabs: const [
              Tab(text: 'Estantes'),
              Tab(text: 'Empréstimos'),
              Tab(text: 'Meus Livros'),
            ],
            labelStyle: const TextStyle(),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: colorScheme.primary,
            dividerHeight: 2,
            dividerColor: colorScheme.primary.withOpacity(.6),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: _searchController,
          builder: (context, textEditingValue, _) {
            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BookcasePage(searchQuery: textEditingValue.text),
                const LoanPage(),
                const MyBooksPage(),
              ],
            );
          },
        ),
      ),
    );
  }
}
