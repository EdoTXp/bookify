import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PlayAlarmSoundService {
  static Future<void> playAlarm([
    double volume = 0.1,
    bool looping = true,
  ]) async {
    assert(
      volume >= 0.0 && volume <= 1.0,
      'The volume value must be between [0.0 and 1.0].',
    );

    await FlutterRingtonePlayer().play(
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      volume: volume,
      looping: looping,
      asAlarm: true,
    );
  }

  static Future<void> stop() async {
    await FlutterRingtonePlayer().stop();
  }
}
