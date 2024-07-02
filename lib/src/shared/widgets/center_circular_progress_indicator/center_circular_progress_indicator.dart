import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  final bool withAdaptive;

  const CenterCircularProgressIndicator({
    super.key,
    this.withAdaptive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: withAdaptive
          ? const CircularProgressIndicator.adaptive()
          : const CircularProgressIndicator(),
    );
  }
}
