import 'package:flutter/material.dart';
import 'package:music_player/src/models/audioplayer_provider.dart';
import 'package:provider/provider.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context, listen: false);
    audioPlayerProvider.playAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((_) => audioPlayerProvider.open());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () {
            audioPlayerProvider.onTapPlay();
          },
          onHorizontalDragEnd: (DragEndDetails drag) {
            if (drag.primaryVelocity == null) return;
            if (drag.primaryVelocity! < 0) {
              // drag from right to left
              audioPlayerProvider.assetAudioPlayer.previous().then((value) =>
                  audioPlayerProvider.currentSong = audioPlayerProvider.assetAudioPlayer.current.value!.index);
            } else {
              // drag from left to right
              audioPlayerProvider.assetAudioPlayer.next().then((value) =>
                  audioPlayerProvider.currentSong = audioPlayerProvider.assetAudioPlayer.current.value!.index);
            }
          },
          child: Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                color: const Color(0xff201e28),
                progress: audioPlayerProvider.playAnimation,
              )),
        ));
  }
}
