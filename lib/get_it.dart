import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AssetsAudioPlayer>(AssetsAudioPlayer());
}
