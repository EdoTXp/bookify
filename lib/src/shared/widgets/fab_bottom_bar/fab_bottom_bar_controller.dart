import 'package:flutter/material.dart';

class FabBottomBarController extends ValueNotifier<int> {
  FabBottomBarController() : super(0);

  void changeSelectedBottomBarItem(int selectedItem) {
    value = selectedItem;
    notifyListeners();
  }
}
