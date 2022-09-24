import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        focusColor: Colors.pink,
        hintText: 'Título, autor(a), ISBN...',
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: Colors.pink,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
