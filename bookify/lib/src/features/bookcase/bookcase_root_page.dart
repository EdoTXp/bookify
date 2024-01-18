import 'package:bookify/src/features/bookcase/views/views.dart';
import 'package:flutter/material.dart';

class BookcaseRootPage extends StatefulWidget {
  const BookcaseRootPage({super.key});

  @override
  State<BookcaseRootPage> createState() => _BookcaseRootPageState();
}

class _BookcaseRootPageState extends State<BookcaseRootPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          tabAlignment: TabAlignment.fill,
          tabs: const [
            SafeArea(child: Tab(text: 'Estantes')),
            SafeArea(child: Tab(text: 'Empréstimos')),
            SafeArea(child: Tab(text: 'Salvos')),
          ],
          labelStyle: const TextStyle(),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: colorScheme.primary,
          dividerHeight: 2,
          dividerColor: colorScheme.primary.withOpacity(.6),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            BookcasePage(),
            LoanPage(),
            SavedBooksPage(),
          ],
        ),
      ),
    );
  }
}
