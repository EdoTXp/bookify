import 'package:flutter/material.dart';
import 'book_showcase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BookShowcase(),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.blue,
          currentIndex: index,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                activeIcon: Icon(Icons.home),
                label: 'Início'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/icons/shelf.png'), label: 'Estantes'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.auto_stories_outlined,
                ),
                activeIcon: Icon(Icons.auto_stories),
                label: 'Leituras'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ),
                activeIcon: Icon(Icons.person),
                label: 'Perfil'),
          ]),
    );
  }
}
