import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LockScreenOrientationService {
  static void lockOrientationScreen({required Orientation orientation}) {
    if (orientation == Orientation.portrait) {
      // Lock the screen only portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return;
    }

    // Lock the screen only landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void unLockOrientationScreen() {
    // Unlock the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
