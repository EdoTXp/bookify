import 'package:wakelock_plus/wakelock_plus.dart';

abstract class WakeLockScreenHelper {
  WakeLockScreenHelper._();

  static void lockWakeScreen() {
    WakelockPlus.toggle(enable: true);
  }

  static void unlockWakeScreen() {
    WakelockPlus.toggle(enable: false);
  }
}
