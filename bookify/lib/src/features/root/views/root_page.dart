import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookify/src/features/qr_code_scanner/views/qr_code_scanner_page.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:bookify/src/shared/widgets/fab_bottom_bar/fab_bottom_bar_controller.dart';
import 'package:bookify/src/shared/blocs/book_bloc/book_bloc.dart';
import 'package:bookify/src/shared/widgets/floating_action_button/rectangle_floating_action_button.dart';
import 'package:bookify/src/features/root/views/pages/pages.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _pageController = PageController();
  final _bottomBarController = FabBottomBarController();
  late final BookBloc bookBloc;

  @override
  void initState() {
    bookBloc = context.read<BookBloc>();
    super.initState();
  }

  @override
  void dispose() {
    bookBloc.close();
    _pageController.dispose();
    _bottomBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          BookshelfPage(),
          ReadingsPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RectangleFloatingActionButton(
        onPressed: (() async {
          int homePage = _pageController.initialPage;

          String isbn = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const QrCodeScannerPage()));
          bookBloc.add(FindedBooksByIsbnEvent(isbn: isbn));
          _pageController.jumpToPage(homePage);
          _bottomBarController.changeSelectedBottomBarItem(homePage);
        }),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: rectangeRoundedNotchedShape,
        onSelectedItem: _pageController.jumpToPage,
        controller: _bottomBarController,
        items: [
          FABBottomAppBarItem(
              unselectedIcon: Icons.home_outlined,
              selectedIcon: Icons.home,
              text: 'Início'),
          FABBottomAppBarItem(
              unselectedIcon: Icons.book_outlined,
              selectedIcon: Icons.book,
              text: 'Estantes'),
          FABBottomAppBarItem(
              unselectedIcon: Icons.auto_stories_outlined,
              selectedIcon: Icons.auto_stories,
              text: 'Leituras'),
          FABBottomAppBarItem(
              unselectedIcon: Icons.person_outline,
              selectedIcon: Icons.person,
              text: 'Perfil'),
        ],
      ),
    );
  }
}
