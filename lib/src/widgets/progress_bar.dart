import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/get_it.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  late StreamSubscription<Duration> listenDuration;
  late StreamSubscription<Playing?> listenPlayingAudio;
  Duration songDuration = const Duration(milliseconds: 0);
  Duration current = const Duration(milliseconds: 0);
  late double porcentaje = 0.0;

  @override
  void dispose() {
    listenDuration.cancel();
    listenPlayingAudio.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var assetAudioPlayer = getIt.get<AssetsAudioPlayer>();

      listenDuration = assetAudioPlayer.currentPosition.listen((duration) {
        current = duration;
        porcentaje = (songDuration.inSeconds > 0) ? current.inSeconds / songDuration.inSeconds : 0;
        setState(() {});
      });
      listenPlayingAudio = assetAudioPlayer.current.listen((playingAudio) {
        songDuration = playingAudio?.audio.duration ?? const Duration(seconds: 0);
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));

    const progressBarHeight = 200.0;
    return Column(
      children: [
        Text(printDuration(songDuration), style: estilo),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 3,
              height: progressBarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Container(
              width: 3,
              height: progressBarHeight * porcentaje,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(printDuration(current), style: estilo),
      ],
    );
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
