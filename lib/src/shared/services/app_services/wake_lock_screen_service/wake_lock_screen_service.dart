import 'package:wakelock_plus/wakelock_plus.dart';

class WakeLockScreenService {
  static void lockWakeScreen() {
    WakelockPlus.toggle(enable: true);
  }

  static void unlockWakeScreen() {
    WakelockPlus.toggle(enable: false);
  }
}
