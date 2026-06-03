import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  
  // Initialize (preload if needed)
  static Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  static Future<void> playBeerOpen() async {
    try {
      // Assuming the user will place the file at assets/sounds/beer_open.mp3
      // We use AssetSource which looks in assets/
      await _player.play(AssetSource('sounds/beer_open.mp3'));
    } catch (e) {
      if (kDebugMode) {
        print("Error playing sound: $e");
      }
    }
  }

  static Future<void> playJackpot() async {
    try {
      await _player.play(AssetSource('sounds/jackpot.mp3'));
    } catch (e) {
       // Ignore if missing
    }
  }
}
