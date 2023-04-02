import 'package:flutter/material.dart';
import '../buttons/publisher_circular_button.dart';

class PublisherListView extends StatelessWidget {
  final List<String> publishers;

  const PublisherListView({Key? key, required this.publishers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: publishers.length,
      itemBuilder: (_, index) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PublisherCircularButton(
              publisher: publishers[index],
            ));
      },
    );
  }
}
