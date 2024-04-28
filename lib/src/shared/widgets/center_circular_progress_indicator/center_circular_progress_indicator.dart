import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  final bool withAdpative;

  const CenterCircularProgressIndicator({
    super.key,
    this.withAdpative = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: withAdpative
          ? const CircularProgressIndicator.adaptive()
          : const CircularProgressIndicator(),
    );
  }
}
