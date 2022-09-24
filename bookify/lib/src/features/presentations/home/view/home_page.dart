import 'package:bookify/src/features/presentations/home/view/pages/bookshelf/bookshelf_page.dart';
import 'package:bookify/src/features/presentations/home/view/pages/profile/profile_page.dart';
import 'package:bookify/src/features/presentations/home/view/pages/readings/readings_page.dart';
import 'package:bookify/src/features/presentations/home/widgets/fab_bottom_bar/fab_bottom_bar.dart';
import 'package:bookify/src/features/presentations/home/widgets/floating_action_button/rectangle_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'pages/book_showcase/book_showcase_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
          RectangleFloatingActionButton(
            onPressed: (() {}),
            width: 60,
            height: 60,
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: rectangeRoundedNotchedShape,
        color: Colors.blue,
        selectedColor: Colors.pink,
        onTabSelected: (value) {
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        items: [
          FABBottomAppBarItem(
              iconData: Icons.home_outlined,
              selectedIcon: Icons.home,
              text: 'Início'),
          FABBottomAppBarItem(
              iconData: Icons.book_outlined,
              selectedIcon: Icons.book,
              text: 'Estantes'),
          FABBottomAppBarItem(
              iconData: Icons.auto_stories_outlined,
              selectedIcon: Icons.auto_stories,
              text: 'Leituras'),
          FABBottomAppBarItem(
              iconData: Icons.person_outline,
              selectedIcon: Icons.person,
              text: 'Perfil')
        ],
      ),
    );
  }
}
