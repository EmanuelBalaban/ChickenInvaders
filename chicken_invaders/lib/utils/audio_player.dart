import 'package:flame_audio/flame_audio.dart' as flame_audio;
import 'package:just_audio/just_audio.dart' as just_audio;

import 'package:chicken_invaders/models/platform.dart';

class AudioPlayer {
  const AudioPlayer._();

  static Future<void> play(
    String assetName, {
    required double volume,
    Platform? platform,
  }) async {
    final currentPlatform = platform ?? Platform.current();

    if (currentPlatform == Platform.web) {
      final player = just_audio.AudioPlayer();
      await player.setAsset('assets/audio/$assetName');
      await player.setVolume(volume);
      await player.play();
      await player.stop();

      return;
    }

    await flame_audio.FlameAudio.play(
      assetName,
      volume: volume,
    );
  }
}
