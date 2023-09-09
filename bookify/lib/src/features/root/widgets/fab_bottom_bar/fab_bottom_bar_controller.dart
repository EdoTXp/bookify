import 'package:flutter/material.dart';

class FabBottomBarController extends ValueNotifier<int> {
  FabBottomBarController() : super(0);

  void changeSelectedBottomBarItem(int item) {
    value = item;
    notifyListeners();
  }
}
