import 'dart:async';

import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/shared/constants/audios/bookify_audios.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bookify/src/shared/enums/platform_error_code.dart';

class PlayAlarmSoundHelper {
  final String assetSound;
  final double volume;
  final bool loopingAlarm;
  late final AudioPlayer player;

  PlayAlarmSoundHelper({
    this.assetSound = BookifyAudios.timerAudio,
    this.volume = 0.1,
    this.loopingAlarm = true,
  }) {
    assert(
      volume >= 0.0 && volume <= 1.0,
      'The volume value must be between [0.0 and 1.0].',
    );

    player = AudioPlayer(playerId: 'AlarmSoundPlayer');

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
    try {
      await _playSound(volume);
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  Future<void> stop() async {
    try {
      await player.stop();
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  Future<void> dispose() async {
    try {
      await player.dispose();
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }

  Future<void> _playSound(double volume) async {
    try {
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
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        PlatformErrorCode.unknown,
        descriptionMessage: e.toString(),
      );
    }
  }
}
