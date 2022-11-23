import 'package:flutter/material.dart';
import 'pages/pages.dart';
import '../widgets/fab_bottom_bar/fab_bottom_bar.dart';
import '../widgets/floating_action_button/rectangle_floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // when the keyboard appears, FAB hides
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          BookShowcasePage(),
          BookshelfPage(),
          ReadingsPage(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Visibility(
            visible: !keyboardIsOpen,
            child: RectangleFloatingActionButton(
              onPressed: (() {}),
              width: 60,
              height: 60,
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: rectangeRoundedNotchedShape,
        // color: const Color(0xFF62B2DE),
        // selectedColor: const Color(0xFFFF8CA2),
        onSelectedItem: _pageController.jumpToPage,
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
              text: 'Perfil')
        ],
      ),
    );
  }
}
