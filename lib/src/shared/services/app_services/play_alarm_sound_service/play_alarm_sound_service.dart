import 'dart:async';

import 'package:bookify/src/shared/constants/audios/bookify_audios.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayAlarmSoundService {
  final AudioPlayer player = AudioPlayer();
  final String assetSound;
  final double volume;
  final bool loopingAlarm;

  PlayAlarmSoundService({
    this.assetSound = BookifyAudios.timerAudio,
    this.volume = 0.1,
    this.loopingAlarm = true,
  }) {
    assert(
      volume >= 0.0 && volume <= 1.0,
      'The volume value must be between [0.0 and 1.0].',
    );

    if (loopingAlarm) {
      player.onPlayerStateChanged.listen(
        (state) async {
          // on end the sound repeat some sound in loop.
          if (state == PlayerState.completed) {
            await _playSound(volume);
          }
        },
      );
    }
  }

  Future<void> playAlarm() async {
    await _playSound(volume);
  }

  Future<void> stop() async {
    await player.stop();
  }

  void dispose() {
    player.dispose();
  }

  Future<void> _playSound(double volume) async {
    await player.play(
      AssetSource(
        assetSound.replaceRange(0, 7, ''),
      ),
      ctx: AudioContext(
        android: const AudioContextAndroid(
          usageType: AndroidUsageType.alarm,
          stayAwake: true,
          audioMode: AndroidAudioMode.ringtone,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
        ),
      ),
      volume: volume,
    );
  }
}
